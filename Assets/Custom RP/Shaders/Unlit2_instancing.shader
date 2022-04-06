Shader "Custom RP/GPU_INSTANCING/Unlit2"
{
    Properties
    {
    	_BaseMap("Texture", 2D) = "white" {}
        _MainColor ("Texture", Color) = (1.0, 0.4, 1.0, 1.0)
    	[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
    	[Enum(Off, 0, On, 1)] _ZWrite ("Z Write", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
        	Blend [_SrcBlend] [_DstBlend]
        	Zwrite [_ZWrite]
			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma vertex UnlitPassVertex
			#pragma fragment UnlitPassFragment
			#include "UnlitPass2.hlsl"
			ENDHLSL
        }
    }
}
