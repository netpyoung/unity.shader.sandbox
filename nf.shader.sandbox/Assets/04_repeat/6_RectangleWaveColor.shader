Shader "repeat/0_frac10"
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

			half Box(half2 st, half size)
			{
				size = 0.5 + size * 0.5;
				st = step(st, size) * step(1.0 - st, size);
				return st.x * st.y;
			}

			half Wave(half2 st, half n)
			{
				st = (floor(st * n) + 0.5) / n;
				half d = distance(0.5, st);
				return (1 + sin(d * 3 - _Time.y * 3)) * 0.5;
			}

			half Box_Wave(half2 uv, half n)
			{
				half2 st = frac(uv * n);
				half size = Wave(uv, n);
				return Box(st, size);
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				return half4(
					Box_Wave(IN.uv, 9),
					Box_Wave(IN.uv, 18),
					Box_Wave(IN.uv, 36),
					1);
			}


			ENDHLSL
		}
	}
}
