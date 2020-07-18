Shader "Hidden/BitColorizer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_RedPrecision("degree of precision of red", float) = 1
		_GreenPrecision("degree of precision of green", float) = 1
		_BluePrecision("degree of precision of blue", float) = 1
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
			float _RedPrecision;
			float _GreenPrecision;
			float _BluePrecision;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col.r = floor(col.r * _RedPrecision + 0.5) / _RedPrecision;
				col.g = floor(col.g * _GreenPrecision + 0.5) / _GreenPrecision;
				col.b = floor(col.b * _BluePrecision + 0.5) / _BluePrecision;
                return col;
            }
            ENDCG
        }
    }
}
