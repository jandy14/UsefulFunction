Shader "Hidden/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Amount ("Amount", float) = 0.1
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
			float _Amount;
			float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

            fixed4 frag (v2f i) : SV_Target
            {
				float noise = rand(i.uv) * 0.1 - 0.05;
				fixed4 col[9];
				col[0] = tex2D(_MainTex, i.uv + fixed2(-1, 1) * (_Amount ) );
				col[1] = tex2D(_MainTex, i.uv + fixed2(0, 1) * (_Amount ) );
				col[2] = tex2D(_MainTex, i.uv + fixed2(1, 1) * (_Amount ) );
				col[3] = tex2D(_MainTex, i.uv + fixed2(1, 0) * (_Amount ) );
				col[4] = tex2D(_MainTex, i.uv + fixed2(1, -1) * (_Amount ) );
				col[5] = tex2D(_MainTex, i.uv + fixed2(0, -1) * (_Amount ) );
				col[6] = tex2D(_MainTex, i.uv + fixed2(-1, -1) * (_Amount ) );
				col[7] = tex2D(_MainTex, i.uv + fixed2(-1, 0) * (_Amount ) );
				col[8] = tex2D(_MainTex, i.uv + fixed2(0, 0) * (_Amount ));

				fixed4 res = 0;
				for (int i = 0; i < 8; ++i)
				{
					res += col[i];
				}
				res *= 0.125;
				res = res * 0.5 + col[8] * 0.5;
                return res;
            }
            ENDCG
        }
    }
}
