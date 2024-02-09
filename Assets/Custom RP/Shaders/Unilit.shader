Shader "Custom RP/Unlit" {
	
	Properties 
	{
		_BaseColor("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	
	SubShader {
		
		Pass {
			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma enable_d3d11_debug_symbols
			#pragma vertex UnlitPassVertex
			#pragma fragment UnlitPassFragment
			#include "UnlitPass.hlsl"
			ENDHLSL
		}
	}
}