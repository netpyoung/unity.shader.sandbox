Shader "basicskill/06_Morping"
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

			// 정사각형의 거리함수
			half2 Square(half2 p)
			{
				return half2(abs(p.x) + abs(p.y), 0.5);
			}

			// 원의 거리함수
			half2 Circle(half2 p)
			{
				return half2(length(p), 0.7);
			}

			half4 frag(VStoFS IN) : SV_Target
			{
				half2 p = (IN.uv - 0.5) * 2;

				half a = sin(_Time.y * 5.0) * 0.5 + 0.5;

				half2 d = lerp(Circle(p), Square(p), a);
				half3 color = lerp(1, 0, step(d.x, d.y));
				return half4(color, 1);
			}
			ENDHLSL
		}
	}
}
