#ifndef CUSTOM_UNLIT_PASS_INCLUDED
#define CUSTOM_UNLIT_PASS_INCLUDED

#include "UnityInput.hlsl"

float4 UnlitPassVertex (float3 positionOS : POSITION) : SV_POSITION {
    return TransformObjectToHClip(positionOS);
}

float4 UnlitPassFragment ():SV_TARGET 
{
    return 1.0;
}

#endif