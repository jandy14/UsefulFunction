Shader "Hidden/LEDMosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Amount ("Amount", Vector) = (16,9,0,0)
    }
    SubShader
    {
		Tags { "RenderType" = "Opaque" }

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
				fixed4 col = 0;
				fixed2 coord = i.uv * amount;
				if (distance(frac(coord), float2(0.5, 0.5)) < 0.4)
				{
					col = 1;
				}
				col *= tex2D(_MainTex, (floor(coord) + float2(0.5, 0.5)) / amount);
                
                return col;
            }
            ENDCG
        }
    }
}
