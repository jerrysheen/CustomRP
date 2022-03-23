using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

partial class CameraRenderer
{
    partial void DrawUnsupportedShaders ();
    partial void DrawGizmos();
    partial void PrepareForSceneWindow ();
    partial void PrepareBuffer ();

#if UNITY_EDITOR
    string SampleName { get; set; }
    
    partial void PrepareBuffer ()
    {
        SampleName = _camera.name;
        buffer.name = _camera.name;
    }
#else
    const string SampleName = bufferName;
#endif
    
#if UNITY_EDITOR
    static Material _errorMaterial;

    static ShaderTagId[] legacyShaderTagIds = {
        new ShaderTagId("Always"),
        new ShaderTagId("ForwardBase"),
        new ShaderTagId("PrepassBase"),
        new ShaderTagId("Vertex"),
        new ShaderTagId("VertexLMRGBM"),
        new ShaderTagId("VertexLM")
    };
    
    partial void DrawGizmos () {
        if (Handles.ShouldRenderGizmos()) {
            _context.DrawGizmos(_camera, GizmoSubset.PreImageEffects);
            _context.DrawGizmos(_camera, GizmoSubset.PostImageEffects);
        }
    }
    
    partial void PrepareForSceneWindow () {
        if (_camera.cameraType == CameraType.SceneView) {
            ScriptableRenderContext.EmitWorldGeometryForSceneView(_camera);
        }
    }
    
    partial void DrawUnsupportedShaders () {
        var drawingSettings = new DrawingSettings(
            legacyShaderTagIds[0], new SortingSettings(_camera)
        ){
            overrideMaterial = _errorMaterial
        };
        for (int i = 1; i < legacyShaderTagIds.Length; i++) {
            drawingSettings.SetShaderPassName(i, legacyShaderTagIds[i]);
        }
        if (_errorMaterial == null) {
             _errorMaterial = new Material(Shader.Find("Hidden/InternalErrorShader"));
        }
        var filteringSettings = FilteringSettings.defaultValue;
        _context.DrawRenderers(
            _cullingResults, ref drawingSettings, ref filteringSettings
        );
    }
#endif
}