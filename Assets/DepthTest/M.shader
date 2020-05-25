Shader "Unlit/M"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
				float4 pos : TEXCOORD1;
				float4 posp : TEXCOORD2;
				float4 posc :  TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.posc = UnityObjectToClipPos(v.vertex);
				o.pos = mul(UNITY_MATRIX_M, v.vertex);
				o.posp = mul(UNITY_MATRIX_MV,v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = i.pos;
			if (frac(i.pos.x) < 0.01 || frac(i.pos.x) > 0.99)
			{
				col = 1;
			}
			if (frac(i.pos.y) < 0.01 || frac(i.pos.y) > 0.99)
			{
				col = 1;
			}
			if (length(i.pos.xy) < 0.04)
			{
				col = float4(0.1,0.5,0.9,1);
			}

				return col;
			}
			ENDCG
        }
    }
}
