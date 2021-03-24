Shader "basicskill/13_CircleWave"
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

			// float Hash(uint s)
			// https://github.com/Unity-Technologies/Graphics/blob/f9f231b6c62fcad3a15bed602c15300e37fb2e3a/com.unity.render-pipelines.core/ShaderLibrary/Random.hlsl#L73

			half2 Hash2(half p)
			{
				// ref: https://www.shadertoy.com/view/4djSRW
				half3 p3 = frac(p * half3(0.1031, 0.1030, 0.0973));
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				half2 p = (IN.uv - 0.5) * 2;

				// 의사 난수로 좌표를 상하좌우로 흔들기
				p += (Hash2(_Time.y) * 2 - 1) * 0.14;
				// 감쇠시키기
				p *= exp(-6.5 * frac(_Time.y));

				half d = Circle(p);
				half3 color = 1 - smoothstep(0.39, 0.4, d);

				return half4(color, 1);
			}
			ENDHLSL
		}
	}
}
