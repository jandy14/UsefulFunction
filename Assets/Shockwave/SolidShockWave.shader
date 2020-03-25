Shader "Unlit/SolidShockWave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Distance ("Distance", float) = 100
		_Thickness ("Thickness", float) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		GrabPass{ "_BgTex" }

        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha
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
			float _Distance;
			float _Thickness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = fixed4(1,1,1,1);
				float2 center = float2(_ScreenParams.x * 0.5, _ScreenParams.y * 0.5);
				float dist = distance(i.vertex.xy, center);
				float2 move = normalize(i.vertex.xy - center) * 20;
				float2 uv = (i.vertex + move) * float4(_ScreenParams.z - 1, _ScreenParams.w - 1, 1, 1);
				col = tex2D(_BgTex, uv);
				col += 0.1;

				if (abs(_Distance - dist) < _Thickness)
				{
					col.a = 1;
				}
				else
				{
					col.a = 0;
				}
				


				return col;
            }
            ENDCG
        }
    }
}
