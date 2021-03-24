Shader "repeat/2_RectangelBlink"
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

			// 지정한 크기의 사각형을 그리는 함수
			half Box(half2 st, half size)
			{
				size = 0.5 + size * 0.5;
				st = step(st, size) * step(1.0 - st, size);
				return st.x * st.y;
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				half n = 10;
				half2 st = frac(IN.uv * n);
				return Box(st, abs(sin(_Time.y * 3)));
			}
			ENDHLSL
		}
	}
}
