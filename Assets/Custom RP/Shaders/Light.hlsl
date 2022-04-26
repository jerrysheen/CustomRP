#ifndef CUSTOM_LIGHT_INCLUDED
#define CUSTOM_LIGHT_INCLUDED


#define MAX_DIRECTIONAL_LIGHT_COUNT 4

CBUFFER_START(_CustomLight)
    //float4 _DirectionalLightColor;
    //float4 _DirectionalLightDirection;
    int _DirectionalLightCount;
    float4 _DirectionalLightColors[MAX_DIRECTIONAL_LIGHT_COUNT];
    float4 _DirectionalLightDirections[MAX_DIRECTIONAL_LIGHT_COUNT];
    float4 _DirectionalLightShadowData[MAX_DIRECTIONAL_LIGHT_COUNT];
CBUFFER_END

struct Light {
    float3 color;
    float3 direction;
    float attenuation;
};

int GetDirectionalLightCount () {
    return _DirectionalLightCount;
}

struct ShadowData_SelfDefined {
    int cascadeIndex;
};

ShadowData_SelfDefined GetShadowData (Surface surfaceWS) {
    ShadowData_SelfDefined data;
    data.cascadeIndex = 3;
    return data;
}


DirectionalShadowData GetDirectionalShadowData (
    int lightIndex, ShadowData_SelfDefined shadowData)
{
    DirectionalShadowData data;
    data.strength = _DirectionalLightShadowData[lightIndex].x;
    data.tileIndex = _DirectionalLightShadowData[lightIndex].y + shadowData.cascadeIndex;
    return data;
}

Light GetDirectionalLight (int index, Surface surfaceWS, ShadowData_SelfDefined shadowData) {
    Light light;
    light.color = _DirectionalLightColors[index].rgb;
    light.direction = _DirectionalLightDirections[index].xyz;
    DirectionalShadowData dirShadowData =
    GetDirectionalShadowData(index, shadowData);
    light.attenuation = GetDirectionalShadowAttenuation(dirShadowData, surfaceWS);
    return light;
}

#endif