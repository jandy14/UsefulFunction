Shader "Hidden/SwitchSceneUsingTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ThresholdTex("ThresholdTex", 2D) = "white" {}
		_Threshold("Threshold", float) = 0
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
			sampler2D _ThresholdTex;
			float _Threshold;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				//col *= step(_Threshold, tex2D(_ThresholdTex, i.uv).r);
				//col *= smoothstep(tex2D(_ThresholdTex, i.uv).r, _Threshold, _Threshold + 0.001);
				col = lerp(fixed4(0, 0, 0, 1), col, clamp((tex2D(_ThresholdTex, i.uv).r - _Threshold) / 0.01,0,1));
				return col;
            }
            ENDCG
        }
    }
}
