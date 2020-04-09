Shader "Unlit/HologramWithLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OutLineColor ("OutLineColor", Color) = (1,1,1,1)
		_InnerColor ("InnerColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
		Tags { "LightMode" = "ForwardBase" }

		Cull Off
		Zwrite Off
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
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 worldPos : TEXCOORD1;
				float rim : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _OutLineColor;
			fixed4 _InnerColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
				o.rim = dot(v.normal, normalize(ObjSpaceViewDir(v.vertex)));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col = lerp(col, _InnerColor, 0.5);
				col.a = step(0.5, frac(i.worldPos.y * 20 + _Time.y)) * 0.3 + 0.1;
				//col = 0;
				fixed4 rim = _OutLineColor * (1- abs(i.rim)) * 0.5;


				//col.a *= step(unity_LightAtten[0].w, pow(distance(unity_LightPosition[0].xyz, mul(UNITY_MATRIX_V, i.vertex).xyz), 2));
				//col.a = distance(unity_LightPosition[1].xyz, mul(UNITY_MATRIX_V, i.vertex).xyz);
				//col = unity_LightPosition[0];
                return col + rim;
            }
            ENDCG
        }
    }
}
