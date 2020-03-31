﻿Shader "Unlit/MeshVisualizer"	
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("LineColor", Color) = (1,1,1,1)
		_Thickness ("Thickness", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }

        Pass
        {
			cull off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
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
				float4 worldPos : TEXCOORD1;
			};
            struct g2f
            {
                float4 vertex : SV_POSITION;
				float3 dist : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			float _Thickness;

            v2g vert (appdata v)
            {
                v2g o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
			{
				g2f o;
				float l0 = distance(IN[1].worldPos.xyz, IN[2].worldPos.xyz);
				float l1 = distance(IN[2].worldPos.xyz, IN[0].worldPos.xyz);
				float l2 = distance(IN[0].worldPos.xyz, IN[1].worldPos.xyz);
				float s = (l0 + l1 + l2) * 0.5;
				float area = sqrt(s * (s - l0) * (s - l1) * (s - l2)) * 2;
				
				o.vertex = IN[0].vertex;
				o.dist = float3(area/l0, 0, 0);
				triStream.Append(o);
				
				o.vertex = IN[1].vertex;
				o.dist = float3(0, area/l1, 0);
				triStream.Append(o);
				
				o.vertex = IN[2].vertex;
				o.dist = float3(0, 0, area/l2);
				triStream.Append(o);
				
				triStream.RestartStrip();
			}

            fixed4 frag (g2f i) : SV_Target
            {
				float dist = min(min(i.dist.x, i.dist.y), i.dist.z);
				fixed4 col = _Color * step(dist, _Thickness);
                return col;
            }
            ENDCG
        }
    }
}
