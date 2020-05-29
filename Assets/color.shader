Shader "Unlit/color"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Vector ("Vector", Vector) = (1,0,0,0)
		_Blur ("Blur", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
			float4 _Vector;
			float _Blur;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 color = fixed4(0.0, 0.0, 0.0, 0.0);
				float iszero = step(0.001, length(_Vector));
				float2 dir = normalize(_Vector.xy);

				color += tex2D(_MainTex, i.uv) * (iszero * -0.65 + 1);
				color += tex2D(_MainTex, i.uv + 4.0 * dir * _Blur) * 0.06 * iszero;
				color += tex2D(_MainTex, i.uv + 3.0 * dir * _Blur) * 0.12 * iszero;
				color += tex2D(_MainTex, i.uv + 2.0 * dir * _Blur) * 0.18 * iszero;
				color += tex2D(_MainTex, i.uv + 1.0 * dir * _Blur) * 0.24 * iszero;

				return color;
            }
            ENDCG
        }
    }
}
