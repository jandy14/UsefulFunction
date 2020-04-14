Shader "Hidden/Glitch"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_LineAmount ("LineAmount", float) = 30
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
			float _LineAmount;
			static const float pi = 3.141592;
			float rand(float n) { return frac(sin(n) * 43758.5453123); }
			float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

            fixed4 frag (v2f i) : SV_Target
			{
				float2 coord = i.uv * _LineAmount;
				float time = floor(floor(coord.y) * pi / _LineAmount + _Time.y * 8);
				fixed4 col = tex2D(_MainTex, i.uv);
				if (sin(time) > 0.8)
				{
					col.r = tex2D(_MainTex, i.uv + float2(sin(rand(floor(coord.y) + time)*pi) * 0.05, 0)).r;// +sin(rand(time) * pi * 2) * 0.2;
					col.g = tex2D(_MainTex, i.uv + float2(cos(rand(floor(coord.y) + time)*pi) * 0.05, 0)).g;// +cos(rand(time) * pi * 2) * 0.2;
					col.b = tex2D(_MainTex, i.uv + float2(rand(floor(coord.y)) * 0.1 - 0.02, 0)).b;// +sin(floor(coord.y) + time) * 0.2;
					col.a = 1;
				} 
				
                return col;
            }
            ENDCG
        }
    }
}
