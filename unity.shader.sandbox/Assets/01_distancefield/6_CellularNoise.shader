Shader "distancefield/6_CellularNoise"
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

			half2 Random2(half2 st)
			{
				st = half2(
					dot(st, half2(127.1, 311.7)),
					dot(st, half2(269.5, 183.3))
				);
				return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				half2 st = IN.uv * 4;
				half2 ist = floor(st);
				half2 fst = frac(st);

				half distance = 5;
				for (int y = -1; y <= 1; y++)
				{
					for (int x = -1; x <= 1; x++)
					{
						half2 neighbor = half2(x, y);
						half2 p = 0.5 + 0.5 * sin(_Time.y + 6.2831 * Random2(ist + neighbor));

						half2 diff = neighbor + p - fst;
						distance = min(distance, length(diff));
					}
				}

				half3 color = distance * 0.5;
				return half4(color, 1);
			}

			ENDHLSL
		}
	}
}
