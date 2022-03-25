#ifndef CUSTOM_UNLIT2_PASS_INCLUDED
#define CUSTOM_UNLIT2_PASS_INCLUDED

#include "UnityInput2.hlsl"

float4 UnlitPassVertex (float3 positionOS : POSITION) : SV_POSITION {
    return TransformObjectToHClip(positionOS);
}

float4 UnlitPassFragment ():SV_TARGET 
{
    return _MainColor;
}

#endif