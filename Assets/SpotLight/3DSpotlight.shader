﻿Shader "Unlit/3DSpotlight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Distance ("Distance", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
				float4 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Distance;
			float4 _MousePosition;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 gray = clamp(col.r * 0.29 + col.g * 0.59 + col.b * 0.12, 0, 1);
				float blend = step(distance(i.worldPos.xyz, _MousePosition.xyz), _Distance);
				col = lerp(gray, col, blend);
                return col;
            }
            ENDCG
        }
    }
}
