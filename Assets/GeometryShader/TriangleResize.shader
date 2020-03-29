Shader "Unlit/TriangleResize"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Size ("Size", Range(0,1)) = 0.9
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		cull off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
			#pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
			struct v2g
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

            struct g2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Size;

            v2g vert (appdata v)
            {
                v2g o;
                o.vertex = v.vertex;
				o.uv = v.uv;
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
			{
				g2f o;
				float4 center = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3;
				for (int i = 0; i < 3; ++i)
				{
					o.vertex = UnityObjectToClipPos(center + (IN[i].vertex - center) * _Size);
					o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
					triStream.Append(o);
				}
				triStream.RestartStrip();
			}

            fixed4 frag (g2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
