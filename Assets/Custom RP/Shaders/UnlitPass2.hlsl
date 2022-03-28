#ifndef CUSTOM_UNLIT2_PASS_INCLUDED
#define CUSTOM_UNLIT2_PASS_INCLUDED

#include "UnityInput2.hlsl"

struct Attributes
{
    float3 positionOS : POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings {
    float4 positionCS : SV_POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


Varyings UnlitPassVertex (Attributes input) : SV_POSITION {
    Varyings output;
    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_TRANSFER_INSTANCE_ID()
    return output;
}

float4 UnlitPassFragment ():SV_TARGET 
{
    return _MainColor;
}

#endif