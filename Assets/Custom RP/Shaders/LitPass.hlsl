#ifndef CUSTOM_LIT_PASS_INCLUDED
#define CUSTOM_LIT_PASS_INCLUDED

#include "UnityInput2.hlsl"
#include "Surface.hlsl"
#include "Shadows.hlsl"
#include "Light.hlsl"
#include "BRDF.hlsl"
#include "Lighting.hlsl"

struct Attributes
{
    float3 positionOS : POSITION;
    float3 normalOS : NORMAL;
    float2 baseUV : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings {
    float4 positionCS : SV_POSITION;
    float3 positionWS : VAR_POSITION;
    float3 normalWS : VAR_NORMAL;
    float2 baseUV : VAR_BASE_UV;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


Varyings LitPassVertex (Attributes input) { 
    Varyings output;
    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    output.baseUV = TRANSFORM_TEX(input.baseUV, _BaseMap);
    output.positionWS = TransformObjectToWorld(input.positionOS);
    output.positionCS = TransformObjectToHClip(input.positionOS);
    output.normalWS = TransformObjectToWorldNormal(input.normalOS);
    return output;
}

float4 LitPassFragment (Varyings input) : SV_TARGET {
    UNITY_SETUP_INSTANCE_ID(input);
    float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);
    float4 baseColor = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _MainColor);
    float4 base = baseMap * baseColor;
    #if defined(_CLIPPING)
    clip(base.a - UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Cutoff));
    #endif
    Surface surface;
    surface.position = input.positionWS;
    surface.normal = normalize(input.normalWS);
    surface.viewDirection = normalize(_WorldSpaceCameraPos - input.positionWS);
    surface.color = base.rgb;
    surface.alpha = base.a;
    surface.metallic = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Metallic);
    surface.smoothness = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Smoothness);
    surface.viewDirection = normalize(_WorldSpaceCameraPos - input.positionWS);
    surface.depth = -TransformWorldToView(input.positionWS).z;
    #if defined(_PREMULTIPLY_ALPHA)
    BRDF brdf = GetBRDF(surface, true);
    #else
    BRDF brdf = GetBRDF(surface);
    #endif
    float3 color = GetLighting(surface, brdf);
    return float4(color, surface.alpha);
}

#endif

