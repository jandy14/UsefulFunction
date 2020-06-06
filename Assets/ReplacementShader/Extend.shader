Shader "Hidden/Extend"
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
                fixed4 col = 0;
				float count = 0;

				fixed4 extend = tex2D(_MainTex, i.uv + float2(_MainTex_TexelSize.x, 0));
				if (length(extend) > 0.001)
				{
					col += extend;
					count++;
				}
				extend = tex2D(_MainTex, i.uv - float2(_MainTex_TexelSize.x, 0));
				if (length(extend) > 0.001)
				{
					col += extend;
					count++;
				}
				extend = tex2D(_MainTex, i.uv + float2(0, _MainTex_TexelSize.y));
				if (length(extend) > 0.001)
				{
					col += extend;
					count++;
				}
				extend = tex2D(_MainTex, i.uv - float2(0, _MainTex_TexelSize.y));
				if (length(extend) > 0.001)
				{
					col += extend;
					count++;
				}
				extend = tex2D(_MainTex, i.uv);
				if (length(extend) > 0.001)
				{
					col += extend;
					count++;
				}
                return col/count;
            }
            ENDCG
        }
    }
}
