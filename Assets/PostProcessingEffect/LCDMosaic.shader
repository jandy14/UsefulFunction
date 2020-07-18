Shader "Hidden/LCDMosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Amount("Amount", Vector) = (16,9,0,0)
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
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float4 _Amount;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 amount = float2(_Amount.x, _Amount.y);
				fixed2 coord = i.uv * amount;
				fixed4 mosaicColor = tex2D(_MainTex, floor(coord) / _Amount);
				if (frac(coord).x < 0.333)
				{
					mosaicColor = fixed4(mosaicColor.x, 0, 0, 1);
				}
				else if (frac(coord).x < 0.666)
				{
					mosaicColor = fixed4(0, mosaicColor.y, 0, 1);
				}
				else
				{
					mosaicColor = fixed4(0, 0, mosaicColor.z, 1);
				}

                return mosaicColor;
            }
            ENDCG
        }
    }
}
