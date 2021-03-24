Shader "basicskill/07_MorpingMulti"
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

			half2 Circle(half2 p)
			{
				return half2(length(p), 0.2);
			}

			half2 Star(half2 p)
			{
				p *= 1.2;

				half a = atan2(p.y, p.x) + _Time.y * 0.3;
				half l = pow(length(p), 0.8);
				half d = l - 0.5 + cos(a * 5.0) * 0.08;

				return half2(d, 0);
			}

			half2 Heart(half2 st)
			{
				st *= 1.5;
				st.y += 0.4;

				float a = st.x;
				float b = st.y - sqrt(abs(st.x));

				return float2(a * a + b * b, 0.6);
			}

			half2 Hex(half2 st)
			{
				st = abs(st);
				half2 r = 0.005;

				return half2(max(st.x - r.y, max(st.x + st.y * 0.57735, st.y * 1.1547) - r.x), 0.4);
			}

			// 거리 보간 함수
			// 입력: p = [-1, 1]의 좌표
			// 반환: half2(x=거리, y=수치)
			half2 Morphing(half2 p)
			{
				half t = _Time.y * 2.5;

				// 거리함수 쌍
				int pair = int(floor(fmod(t, 4.0)));

				// 보간값
				half a = smoothstep(0.2, 0.8, fmod(t, 1.0));

				switch (pair)
				{
				case 0:  return lerp( Heart(p), Circle(p), a);
				case 1:  return lerp(Circle(p),    Hex(p), a);
				case 2:  return lerp(   Hex(p),   Star(p), a);
				default: return lerp(  Star(p),  Heart(p), a);
				}
			}


			half4 frag(VStoFS IN) : SV_Target
			{
				half2 p = (IN.uv - 0.5) * 2;

				half2 d = Morphing(p);
				half3 color = lerp(1, 0, step(d.y, d.x));

				return half4(color, 1);
			}
			ENDHLSL
		}
	}
}
