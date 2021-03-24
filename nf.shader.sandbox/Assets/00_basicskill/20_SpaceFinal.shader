Shader "basicskill/20_SpaceFinal"
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
				half2 p = (IN.uv - 0.5) * 2;

				for (int i = 1; i <= 4; ++i)
				{
					p = abs(p * 1.5) - 1;
					half a = _Time.y * i;
					half c = cos(a);
					half s = sin(a);
					p = mul(half2x2(c, s, -s, c), p);
				}

				half2 axis = 1 - smoothstep(0.01, 0.02, abs(p));
				half2 color = lerp(p, 1, axis.x + axis.y);
				return half4(color, 1, 1);
			}
			ENDHLSL
		}
	}
}
