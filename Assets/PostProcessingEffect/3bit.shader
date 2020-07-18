Shader "Hidden/3bit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            fixed4 frag (v2f i) : SV_Target
            {
				float mods[11] = { 10, 10, 5, 4, 5, 2, 5, 4, 5, 10 ,10};
				float thresholds[11] = { 0, 1, 1, 1, 2, 1, 3, 3, 4, 9 , 10};
                fixed4 c = tex2D(_MainTex, i.uv);
                
				c.r = clamp(c.r,0,1);
				c.g = clamp(c.g,0,1);
				c.b = clamp(c.b,0,1);

				c = floor(c * 10);
				float2 coord = floor(i.uv * _MainTex_TexelSize.zw);
				float p = coord.x + coord.y * 3;

				c.r = step(p - mods[c.r] * floor(p / mods[c.r]), thresholds[c.r] - 0.1);
				c.g = step(p - mods[c.g] * floor(p / mods[c.g]), thresholds[c.g] - 0.1);
				c.b = step(p - mods[c.b] * floor(p / mods[c.b]), thresholds[c.b] - 0.1);

                return c;
            }
            ENDCG
        }
    }
}
