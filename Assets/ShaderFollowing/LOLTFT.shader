Shader "Unlit/LOLTFT"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Fog ("Fog", 2D) = "white" {}
		_Thickness ("Thickness", float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
			float4 _MainTex_TexelSize;
            float4 _MainTex_ST;
			sampler2D _Fog;
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
                fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb = fixed3(1, 1, 1);
				
				fixed4 up = tex2D(_MainTex, i.uv + fixed2(0, _MainTex_TexelSize.y * _Thickness));
				fixed4 down = tex2D(_MainTex, i.uv + fixed2(0, -_MainTex_TexelSize.y * _Thickness));
				fixed4 left = tex2D(_MainTex, i.uv + fixed2(-_MainTex_TexelSize.x * _Thickness, 0));
				fixed4 right = tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x * _Thickness, 0));
				if (up.a * down.a * right.a * left.a == 0)
				{
					col *= fixed4(0, 0, 0, 0.7);
				}
				else
				{
					float alpha = tex2D(_Fog, i.uv + _Time.x).r;
					col.a *= alpha;
				}
                return col;
            }
            ENDCG
        }
    }
}
