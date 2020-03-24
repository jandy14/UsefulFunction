Shader "Unlit/ScreenPos"
{
    Properties
    {
		 _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		GrabPass{ "_BackgroundTexture" }
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
				float4 grabPos : TEXCOORD1;
            };

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BackgroundTexture;

            v2f vert (appdata v)
            {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = tex2Dproj(_BackgroundTexture, i.grabPos );
				col += 0.1;
				col.a = 1;
                return col;
            }
            ENDCG
        }
    }
}
