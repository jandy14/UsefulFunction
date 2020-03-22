Shader "Hidden/Crack"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_CrackImage("CrackImage", 2D) = "white" {}
		_Ratio("Ratio", Vector) = (16,9,0,0)
		_Amount("Amount", int) = 1
		_Threshold("Threshold", float) = 1
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
			sampler2D _CrackImage;
			fixed4 _Ratio;
			int _Amount;
			float _Threshold;
			float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed2 coord = i.uv * fixed2(_Ratio.x, _Ratio.y);
				coord *= _Amount;
				col = tex2D(_CrackImage, (frac(coord) + fixed2( floor(rand(floor(coord)) * 10), 0)) * fixed2(0.1,1) );
				col *= fixed4(rand(floor(coord)), rand(floor(coord).yx), rand(floor(coord).yy), 1);
				return col;
            }
            ENDCG
        }
    }
}
