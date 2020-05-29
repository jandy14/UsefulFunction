Shader "Unlit/OutWave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_Strength ("Strengh", float) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="AlphaTest" }
        LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
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
			sampler2D _Noise;
			float4 _MainTex_TexelSize;
			float _Strength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = tex2D(_MainTex, i.uv);
				float x = (tex2D(_Noise, i.uv * 0.5 + _Time.x).x - 0.5) * 2;
				float y = (tex2D(_Noise, i.uv * 0.5 + 0.5 - _Time.x).y - 0.5) * 2;
				
				if (tex2D(_MainTex, i.uv + float2(x , y) * _Strength).a > 0.001 && col.a < 0.001)
				{
					col = fixed4(1, 1, 0, 1);
				}

				//fixed outline
				fixed up = tex2D(_MainTex, i.uv + fixed2(0, _MainTex_TexelSize.y)).a;
				fixed down = tex2D(_MainTex, i.uv + fixed2(0, -_MainTex_TexelSize.y)).a;
				fixed left = tex2D(_MainTex, i.uv + fixed2(-_MainTex_TexelSize.x, 0)).a;
				fixed right = tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x, 0)).a;

				if (up + down + left + right != 0 && col.a == 0)
				{
					col = fixed4(1, 1, 0, 1);
				}

                return col;
            }
            ENDCG
        }
    }
}
