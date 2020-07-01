Shader "Unlit/HalfInverse"
{
    Properties
    {
		_Noise ("Noise", 2D) = "white" {}
        _MainTex ("Texture", 2D) = "white" {}
		_Dist ("Circle Size", float) = 0
		_MainColor1("MainColor 1", Color) = (0,0,0,1)
		_MainColor2("MainColor 2", Color) = (1,1,1,1)
		_MainColor3("MainColor 3", Color) = (0,0,0,1)
		_MainColor4("MainColor 4", Color) = (1,1,1,1)
		[Toggle] _Invert("Invert color?", Float) = 0
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
				float4 view: TEXCOORD1;
            };

			sampler2D _Noise;
            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _MainColor1;
			fixed4 _MainColor2;
			fixed4 _MainColor3;
			fixed4 _MainColor4;
			float _Invert;
			float _Dist;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.view = mul(UNITY_MATRIX_MV, v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				if (length(i.view.xy) < _Dist)
				{
					_MainColor1 = _MainColor3;
					_MainColor2 = _MainColor4;
				}

				float noise = (tex2D(_Noise, i.view + float2(_Time.x, 0)).r - 0.5) * 0.05;
				noise *= ((_Invert - 0.5) * 2);
				fixed4 col = lerp(_MainColor1, _MainColor2, step(noise, i.view.x * (_Invert - 0.5) * 2));

                return col;
            }
            ENDCG
        }
    }
}
