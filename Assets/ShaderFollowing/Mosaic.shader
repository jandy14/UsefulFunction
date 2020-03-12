Shader "Custom/Mosaic"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
		_Amount("Amount", int) = 20
		_Line("Line", Range(0,1)) = 0.05
		_Move("move", Range(0,1)) = 0
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
			int _Amount;
			float _Line;
			float _Move;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 coord = i.uv;
				coord = coord * _Amount;
				fixed4 mosaicColor = tex2D(_MainTex, floor(coord)/ _Amount);

				if (frac(coord + _Time.y * _Move).x < 0.333)
				{
					mosaicColor = fixed4(frac(coord).x, 0, 0, 1);
				}
				else if (frac(coord + _Time.y * _Move).x < 0.666)
				{
					mosaicColor = fixed4(0, mosaicColor.y, 0, 1);
				}
				else
				{
					mosaicColor = fixed4(0, 0, mosaicColor.z, 1);
				}
				if (frac(coord).x > 1 - _Line * 0.5
					|| frac(coord).x < _Line * 0.5
					|| frac(coord).y < _Line * 0.5
					|| frac(coord).y > 1 - _Line * 0.5)
				{
					mosaicColor = fixed4(0, 0, 0, 1);
				}
				return mosaicColor;
            }
            ENDCG
        }
    }
}
