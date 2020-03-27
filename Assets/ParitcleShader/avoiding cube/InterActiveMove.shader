Shader "Unlit/InterActiveMove"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		[HDR]_Glowness ("Glowness", Color) = (1,1,1,1)
		_Position ("Position", Vector) = (0,0,0,0)
		_Range ("Range", float) = 1
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
				float4 dist : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			float4 _Glowness;
			float4 _Position;
			float _Range;

            v2f vert (appdata v)
            {
                v2f o;
				float4 pivot = mul(unity_WorldToObject, v.vertex);
				pivot = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
				float dist = distance(_Position.xyz, pivot.xyz);
				
				float move = 0;
				if (dist < _Range)
				{
					move = sqrt(pow(_Range, 2) - pow(dist, 2));
				}
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex.y -= move;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.dist.x = move;


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = lerp(_Color, _Glowness, i.dist.x/_Range);
                return col;
            }
            ENDCG
        }
    }
}
