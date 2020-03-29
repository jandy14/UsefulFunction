Shader "Unlit/NormalVisual"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_NormalColor ("Normal Color", Color) = (1,1,0,1)
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			cull off
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma geometry geom
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float2 uv : TEXCOORD0;
				};

				struct v2g
				{
					float4 vertex : SV_POSITION;
					float2 uv : TEXCOORD0;
					float3 normal : NORMAL;
				};

				struct g2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float4 color : COLOR;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _NormalColor;

				v2g vert(appdata v)
				{
					v2g o;
					o.vertex = v.vertex;
					o.normal = v.normal;
					o.uv = v.uv;
					//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				[maxvertexcount(12)]
				void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
				{
					g2f o;
					for (int i = 0; i < 3; ++i)
					{
						o.vertex = UnityObjectToClipPos(IN[i].vertex);
						o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
						o.color = _NormalColor;
						triStream.Append(o);

						o.vertex = UnityObjectToClipPos(IN[i].vertex + IN[i].normal * 0.1 + float4(0.01,0,0,0));
						o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
						o.color = _NormalColor;
						triStream.Append(o);

						o.vertex = UnityObjectToClipPos(IN[i].vertex + IN[i].normal * 0.1 + float4(0, -0.01, 0, 0));
						o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
						o.color = _NormalColor;
						triStream.Append(o);
						triStream.RestartStrip();
					}

					for (int i = 0; i < 3; ++i)
					{
						o.vertex = UnityObjectToClipPos(IN[i].vertex);
						o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
						o.color = float4(1, 1, 1, 1);
						triStream.Append(o);
					}
					triStream.RestartStrip();
				}

				fixed4 frag(g2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = i.color;
					return col;
				}
				ENDCG
			}
		}
}
