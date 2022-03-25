#ifndef CUSTOM_UNITY_INPUT2_INCLUDED
#define CUSTOM_UNITY_INPUT2_INCLUDED
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
CBUFFER_START(UnityPerMaterial)
    float4 _MainColor;
CBUFFER_END
#endif