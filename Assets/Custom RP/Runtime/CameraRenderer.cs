using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

public partial class CameraRenderer
{
    private ScriptableRenderContext _context;
    private Camera _camera;

    private CullingResults _cullingResults;
    private static ShaderTagId unlitShaderTagId = new ShaderTagId("SRPDefaultUnlit");
    static ShaderTagId[] litShaderTagIds = {
        new ShaderTagId("CustomLit"),
        new ShaderTagId("UniversalForward"),
    };

    const string bufferName = "Render Camera";
    private Lighting lighting = new Lighting();
    
    CommandBuffer buffer = new CommandBuffer
    {
        name = bufferName
    };

    public void Render(
        ScriptableRenderContext context, Camera camera,
        bool useDynamicBatching, bool useGPUInstancing,
        ShadowSettings shadowSettings)
    {
        _camera = camera;
        _context = context;
        
        PrepareBuffer();
        PrepareForSceneWindow();
        if (!Cull(shadowSettings.maxDistance))
        {
            return;
        }
        buffer.BeginSample(SampleName);
        ExecuteBuffer();
        lighting.Setup(context, _cullingResults, shadowSettings);
        buffer.EndSample(SampleName);
        Setup();
        DrawVisiableGeometry(useDynamicBatching, useGPUInstancing);
        DrawUnsupportedShaders();
        DrawGizmos();
        lighting.Cleanup();
        Submit();
    }

    void Setup()
    {
        _context.SetupCameraProperties(_camera);
        CameraClearFlags flags = _camera.clearFlags;
        buffer.ClearRenderTarget(			
            flags <= CameraClearFlags.Depth,
            flags == CameraClearFlags.Color,
            Color.clear);
        buffer.BeginSample(SampleName);
        ExecuteBuffer();
    }

    void DrawVisiableGeometry(bool useDynamicBatching, bool useGPUInstancing)
    {
        // 传入的相机参数是为了判断sorting的依据是根据正交相机还是根据透视相机
        var sortingSettings = new SortingSettings(_camera)
        {
            criteria = SortingCriteria.CommonOpaque
        };
        var drawingSettings = new DrawingSettings(
            unlitShaderTagId, sortingSettings
        ){
            enableDynamicBatching = useDynamicBatching,
            enableInstancing = useGPUInstancing,
            perObjectData = PerObjectData.Lightmaps | PerObjectData.LightProbe| PerObjectData.ShadowMask |
                            PerObjectData.LightProbeProxyVolume | PerObjectData.OcclusionProbe
        };
        // draw lit.
        for (int i = 1; i <= litShaderTagIds.Length; i++) {
            drawingSettings.SetShaderPassName(i - 1, litShaderTagIds[i - 1]);
        }
        var filteringSettings = new FilteringSettings(RenderQueueRange.opaque); 
        
        // draw opaque
        _context.DrawRenderers(
            _cullingResults, ref drawingSettings, ref filteringSettings
        );
        
        // draw skybox
        _context.DrawSkybox(_camera);
        
        // draw transparent
        sortingSettings.criteria = SortingCriteria.CommonTransparent;
        drawingSettings.sortingSettings = sortingSettings;
        filteringSettings.renderQueueRange = RenderQueueRange.transparent;
        filteringSettings = new FilteringSettings(RenderQueueRange.transparent);
        _context.DrawRenderers(
            _cullingResults, ref drawingSettings, ref filteringSettings
        );
    }

    void Submit()
    {
        buffer.EndSample(bufferName);
        ExecuteBuffer();
        _context.Submit();
    }

    void ExecuteBuffer()
    {
        _context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    bool Cull(float maxShadowDistance)
    {
        ScriptableCullingParameters p;
        if (_camera.TryGetCullingParameters(out p))
        {
            p.shadowDistance = Mathf.Min(maxShadowDistance, _camera.farClipPlane);;
            _cullingResults = _context.Cull(ref p);
            return true;
        }

        return false;
    }
    
    
}