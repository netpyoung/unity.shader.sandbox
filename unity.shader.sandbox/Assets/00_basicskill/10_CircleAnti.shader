Shader "basicskill/10_CircleAnti"
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

			half Circle(half2 p)
			{
				return length(p);
			}

			half3 Render(half2 p)
			{
				return 1 - step(0.8, Circle(p));
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				half2 p = (IN.uv - 0.5) * 2;

				half3 color = 0;
				const int iter = 4;
				for (int i = 1; i <= iter; ++i)
				{
					half2 offset = half2(step(i, 2), fmod(i, 2));
					offset -= 0.5;
					offset *= 0.0015;

					color += Render(p + offset);
				}
				color /= (float)iter;

				return half4(color, 1);
			}
			ENDHLSL
		}
	}
}
