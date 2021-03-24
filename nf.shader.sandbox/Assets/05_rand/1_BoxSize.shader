Shader "rand/0_BoxSize"
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

			half Box_size(half2 st, half n)
			{
				st = (floor(st * n) + 0.5) / n;
				return (1 + sin(_Time.y * 3)) * 0.5;
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				half n = 10;
				half2 st = frac(IN.uv * n);
				half size = Box_size(IN.uv, n);
				return Box(st, size);
			}

			ENDHLSL
		}
	}
}
