﻿Shader "Hidden/CameraDepth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Distance ("Distance", float) = 0
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
			sampler2D _CameraDepthTexture;
            sampler2D _MainTex;
			float _Distance;
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_CameraDepthTexture, i.uv);
                return step(abs(col.r - _Distance), 0.0005);
            }
            ENDCG
        }
    }
}
