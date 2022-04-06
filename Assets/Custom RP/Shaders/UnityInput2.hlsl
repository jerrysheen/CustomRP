#ifndef CUSTOM_UNITY_INPUT2_INCLUDED
#define CUSTOM_UNITY_INPUT2_INCLUDED
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    UNITY_DEFINE_INSTANCED_PROP(float4, _BaseMap_ST)
    UNITY_DEFINE_INSTANCED_PROP(float4, _MainColor)
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)
#endif