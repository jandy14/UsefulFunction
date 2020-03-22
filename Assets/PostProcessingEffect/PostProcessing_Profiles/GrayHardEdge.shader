Shader "Hidden/GrayHardEdge"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float2 screenPos : TEXCOORD1;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
			// just invert the colors

			float v = col.r * 0.29 + col.g * 0.59 + col.b * 0.12;

			v = floor(v * 10) * 0.1;
			float2 coord = floor(i.uv * _MainTex_TexelSize.zw);
			float p = coord.x + coord.y;
			
			if (v < 0.1)
			{
				v = 0;
			}
			else if (v < 0.4)
			{
				if (p - 2 * floor(p / 2) < 1)
				{
					v = 0;
				}
				else
				{
					v = 1;
				}
			}
			else if (v < 0.7)
			{
				if (p - 4 * floor(p / 4) < 1)
				{
					v = 0;
				}
				else
				{
					v = 1;
				}
			}
			else
			{
				v = 1;
			}

			col = v;

			return col;
			
		}
		ENDCG
	}
	}
}
