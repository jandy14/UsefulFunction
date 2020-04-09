Shader "Unlit/HardRim"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Threshold ("Threshold", float) = 0.3
		_Noise ("Noise", float) = 0.2
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }

        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
				float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {
				float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float rim : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Threshold;
			float _Noise;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.rim = dot(v.normal, normalize(ObjSpaceViewDir(v.vertex)));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 noise = tex2D(_MainTex, i.uv + _Time.x);
				float result = step(i.rim, _Threshold + noise.x * _Noise);
				fixed4 col = fixed4(1, 0, 0, 0.1 +result);

                return col;
            }
            ENDCG
        }
    }
}
