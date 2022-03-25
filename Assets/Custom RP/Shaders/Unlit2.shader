Shader "Custom RP/Unlit2"
{
    Properties
    {
        _MainColor ("Texture", Color) = (1.0, 0.4, 1.0, 1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma vertex UnlitPassVertex
			#pragma fragment UnlitPassFragment
			#include "UnlitPass2.hlsl"
			ENDHLSL
        }
    }
}
