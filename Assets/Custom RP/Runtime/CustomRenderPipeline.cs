using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class CustomRenderPipeline : RenderPipeline
{
    bool useDynamicBatching, useGPUInstancing;
    ShadowSettings shadowSettings;
    public CustomRenderPipeline (
        bool useDynamicBatching, bool useGPUInstancing, bool useSRPBatcher, 
        ShadowSettings shadowSettings
    ) {
        this.useDynamicBatching = useDynamicBatching;
        this.useGPUInstancing = useGPUInstancing;
        GraphicsSettings.useScriptableRenderPipelineBatching = useSRPBatcher;
        GraphicsSettings.lightsUseLinearIntensity = true;
        this.shadowSettings = shadowSettings;
    }

    private CameraRenderer _renderer = new CameraRenderer();
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach (Camera camera in cameras) {
            _renderer.Render(
                context, camera, useDynamicBatching, useGPUInstancing,
                shadowSettings
            );
        }
    }
}
