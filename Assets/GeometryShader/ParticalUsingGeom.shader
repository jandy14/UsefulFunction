Shader "Unlit/ParticalUsingGeom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Size ("Size", float) = 0.5
		_Range("Range", float) = 3
		_Color("Base Color", Color) = (0,0,0,1)
		[HDR]_Glowness("Glow Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
			};

			struct v2g
			{
				float4 vertex : SV_POSITION;
				float dist : TEXCOORD0;
			};

			struct g2f
			{
				float4 vertex : SV_POSITION;
				float dist : TEXCOORD0;
			};

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Size;
			float _Range;
			float4 _Position;
			float4 _Color;
			float4 _Glowness;

			float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }
            
			v2g vert (appdata v)
            {
                v2g o;

				float4 pivot = mul(unity_WorldToObject, v.vertex);
				float dist = distance(_Position.xyz, pivot.xyz);
				float3 move = float3(0, 0, 0);
				if (dist < _Range)
				{
					move = normalize(pivot.xyz - _Position.xyz + float3(0, 1, 0)) * (_Range - dist);
				}

                o.vertex = v.vertex + float4(move.x, move.y, move.z, 0) + float4(sin(rand(v.vertex.xz) + _Time.y),0,cos(rand(v.vertex.zx) + _Time.y),0) * 0.1;
				o.dist = dist;
                return o;
            }
			
			[maxvertexcount(12)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
			{
				g2f o;
				float4 center = IN[0].vertex;
				float dist = IN[0].dist;
				o.vertex = center + float4(-0.5, 0, -0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0.5, 0, -0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0, 0, 0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				triStream.RestartStrip();

				o.vertex = center + float4(-0.5, 0, -0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0, 1, 0, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0.5, 0, -0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				triStream.RestartStrip();

				o.vertex = center + float4(0.5, 0, -0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0, 1, 0, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0, 0, 0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				triStream.RestartStrip();

				o.vertex = center + float4(-0.5, 0, -0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0, 0, 0.5, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				o.vertex = center + float4(0, 1, 0, 0) * _Size;
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.dist = dist;
				triStream.Append(o);
				triStream.RestartStrip();
			}

            fixed4 frag (g2f i) : SV_Target
            {
				fixed4 col = lerp(_Color, _Glowness, clamp((_Range - i.dist) / _Range, 0, 1));
                return col;
            }
            ENDCG
        }
    }
}
