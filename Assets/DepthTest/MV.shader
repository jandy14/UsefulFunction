Shader "Unlit/MV"
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
				o.pos = mul(UNITY_MATRIX_MV, v.vertex);
				o.posp = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = i.pos;
			if (length(i.pos.xy) < 0.02)
			{
				col = 1;
			}
			if (length(i.pos.x) < 0.01)
			{
				col = 1;
			}
			if (length(i.pos.y) < 0.01)
			{
				col = 1;
			}
				return col;
			}
			ENDCG
        }
    }
}
