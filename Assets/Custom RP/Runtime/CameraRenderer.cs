using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

public class CameraRenderer
{
    private ScriptableRenderContext _context;
    private Camera _camera;
    public void Render(ScriptableRenderContext context, Camera camera)
    {
        _camera = camera;
        _context = context;

        Setup();
        DrawVisiableGeometry();
        Submit();
    }

    void Setup()
    {
        _context.SetupCameraProperties(_camera);
    }

    void DrawVisiableGeometry()
    {
        _context.DrawSkybox(_camera);
    }

    void Submit()
    {
        _context.Submit();
    }
}