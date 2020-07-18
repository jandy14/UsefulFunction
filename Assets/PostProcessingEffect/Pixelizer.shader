Shader "Hidden/Pixelizer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_PixelSize("PixelSize", float) = 1
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
			float4 _MainTex_TexelSize;
			float _PixelSize;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = (0,0,0,0);
				float2 coord = floor(i.uv * _MainTex_TexelSize.zw);
				
				float2 screen = _MainTex_TexelSize.zw / _PixelSize;

				float2 f = floor(i.uv * screen);
				//float2 c = ceil(i.uv * screen);

				for (float x = 0; x <= 1; x += 0.5)
				{
					for (float y = 0; y <= 1; y += 0.5)
					{
						col += tex2D(_MainTex, (f + float2(x, y)) / screen);
						//col += tex2D(_MainTex, float2(lerp(f.x, c.x, x), lerp(f.y, c.y, y))/ screen);
					}
				}

				col /= 9;
                return col;
            }
            ENDCG
        }
    }
}
