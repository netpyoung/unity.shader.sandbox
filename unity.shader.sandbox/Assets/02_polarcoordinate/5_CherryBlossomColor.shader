Shader "polarcoordinate/5_CherryBlossomColor"
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

			half4 frag(VStoFS IN) : SV_Target
			{
				half2 st = 0.5 - IN.uv;
				half a = atan2(st.y, st.x);

				half r = length(st);
				half d = min(abs(cos(a * 2.5)) + 0.4, abs(sin(a * 2.5)) + 1.1) * 0.32;

				half4 color = lerp(0.8, half4(0, 0.4, 1, 1), IN.uv.y);

				half petal = step(r, d);
				color = lerp(color, lerp(half4(1, 0.3, 1, 1), 1, r * 2.5), petal);

				half cap = step(distance(0, st), 0.07);
				color = lerp(color, half4(0.99, 0.78, 0, 1), cap);

				return color;
			}

			ENDHLSL
		}
	}
}
