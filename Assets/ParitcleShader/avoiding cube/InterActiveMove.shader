Shader "Unlit/InterActiveMove"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		[HDR]_Glowness("Glowness", Color) = (1,1,1,1)
		_Position("Position", Vector) = (0,0,0,0)
		_Range("Range", float) = 1
		_Volume("Volume", float) = 1
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
			float _Volume;

            v2f vert (appdata v)
            {
                v2f o;
				float4 pivot = mul(unity_WorldToObject, v.vertex);
				pivot = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
				float dist = distance(_Position.xyz, pivot.xyz);
				
				//float move = 0;
				//if (dist < _Range)
				//{
				//	move = sqrt(pow(_Range, 2) - pow(dist, 2));
				//}
				//o.vertex = UnityObjectToClipPos(v.vertex + float4(0,move * _Volume,0,0));

				float3 move = float3(0, 0, 0);
				if (dist < _Range)
				{
					move = normalize(pivot.xyz - _Position.xyz + float3(0,1,0)) * (_Range - dist);
				}
				o.vertex = UnityObjectToClipPos(v.vertex + float4(move.x, move.y, move.z, 0) * _Volume);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				//o.dist.x = move;
				o.dist.x = distance(move, float3(0,0,0));


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
