Shader "Unlit/2DMirror"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Pivot ("Pivot", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		GrabPass{ "_BgTex" }

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _BgTex;
			float _Pivot;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 vertex = float2(i.vertex.x + sin(i.uv.y * 10 + _Time.y) * 10, _Pivot - (i.vertex.y - _Pivot));
				float2 uv = vertex * float4(_ScreenParams.z - 1, _ScreenParams.w - 1, 1, 1);
				fixed4 col = tex2D(_BgTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
