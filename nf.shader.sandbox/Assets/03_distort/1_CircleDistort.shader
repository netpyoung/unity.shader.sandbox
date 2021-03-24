Shader "distort/1_CircleDistort"
{
	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalRenderPipeline"
		}

		Pass
		{
			Tags
			{
				"LightMode" = "UniversalForward"
				"Queue" = "Geometry"
				"RenderType" = "Opaque"
			}

			HLSLPROGRAM
			#pragma target 3.5

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			struct APPtoVS
			{
				float4 positionOS	: POSITION;
				float2 uv			: TEXCOORD0;
			};

			struct VStoFS
			{
				float4 positionCS	: SV_POSITION;
				float2 uv			: TEXCOORD0;
			};

			VStoFS vert(APPtoVS IN)
			{
				VStoFS OUT;
				ZERO_INITIALIZE(VStoFS, OUT);

				OUT.positionCS = TransformObjectToHClip(IN.positionOS.xyz);
				OUT.uv = IN.uv;
				return OUT;
			}

			half Circle(half2 st)
			{
				return step(0.3, distance(0.5, st));
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				// y ÁÂÇ¥¸¦ ÀÌ¿ë xÁÂÇ¥¸¦ ÀÏ±×·¯¶ß¸²
				IN.uv.x += sin(IN.uv.y * 20) * 0.05;
				return Circle(IN.uv);
			}

			ENDHLSL
		}
	}
}
