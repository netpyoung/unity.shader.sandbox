Shader "distort/1_CircleDistortColor"
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
			half box(half2 st, half size)
			{
				size = 0.5 + size * 0.5;
				st = step(st, size) * step(1.0 - st, size);
				return st.x * st.y;
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				// 일그러짐 계산
				half x = 2 * IN.uv.y + sin(_Time.y * 5);
				half distort = sin(_Time.y * 10) * 0.1 *
									 sin(5 * x) * (-(x - 1) * (x - 1) + 1);
				// 좌표 일그러뜨리기
				IN.uv.x += distort;
				// RGB 마다 조금씩 좌표이동
				return half4(
					1 - Circle(IN.uv - half2(0, distort) * 0.3),
					1 - Circle(IN.uv + half2(0, distort) * 0.3),
					1 - Circle(IN.uv + half2(distort, 0) * 0.3),
					1);
			}

			ENDHLSL
		}
	}
}
