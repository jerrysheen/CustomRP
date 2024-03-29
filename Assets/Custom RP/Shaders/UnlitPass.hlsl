#ifndef CUSTOM_UNLIT_PASS_INCLUDED
#define CUSTOM_UNLIT_PASS_INCLUDED

#include "UnityInput.hlsl"

struct Attributes {
    float3 positionOS : POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings {
    float4 positionCS : SV_POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


Varyings UnlitPassVertex (Attributes input){
    UNITY_SETUP_INSTANCE_ID(input);
    Varyings output;
    output.positionCS = TransformObjectToHClip(input.positionOS);
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    return output;
}

float4 UnlitPassFragment(Varyings input) : SV_TARGET 
{
    // PS中应该也要有， unityInstance_ID那个应该是vs ps 分开的
    // 这个地方可以测试一下， 猜测，如果没有这个ID， 可能BaseColor instance取不到
    UNITY_SETUP_INSTANCE_ID(input);
    return UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);
}

#endif