#ifndef CUSTOM_COMMON_INCLUDED
#define CUSTOM_COMMON_INCLUDED
#if defined(_SHADOW_MASK_ALWAYS) || defined(_SHADOW_MASK_DISTANCE)
	#define SHADOWS_SHADOWMASK
#endif

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"



float DistanceSquared(float3 pA, float3 pB) {
	return dot(pA - pB, pA - pB);
}

#endif