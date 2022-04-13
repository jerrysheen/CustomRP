#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

#include "Surface.hlsl"

float3 GetLighting (Surface surface) {
    return surface.normal.x;
}

float3 IncomingLight (Surface surface, Light light) {
    return dot(surface.normal, light.direction) * light.color;
}

#endif