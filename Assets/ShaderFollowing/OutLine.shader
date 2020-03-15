Shader "Unlit/OutLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Outline("Outline", Float) = 0.1
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			half _Outline;
			half4 _OutlineColor;
			
			struct vertexInput
			{
				float4 vertex: POSITION;
			};

			struct vertexOutput
			{
				float4 pos: SV_POSITION;
			};

			float4 CreateOutline(float4 vertPos, float Outline)
			{
				float4x4 scaleMat;
				scaleMat[0][0] = 1.0f + Outline;
				scaleMat[0][1] = 0.0f;
				scaleMat[0][2] = 0.0f;
				scaleMat[0][3] = 0.0f;
				scaleMat[1][0] = 0.0f;
				scaleMat[1][1] = 1.0f + Outline;
				scaleMat[1][2] = 0.0f;
				scaleMat[1][3] = 0.0f;
				scaleMat[2][0] = 0.0f;
				scaleMat[2][1] = 0.0f;
				scaleMat[2][2] = 1.0f + Outline;
				scaleMat[2][3] = 0.0f;
				scaleMat[3][0] = 0.0f;
				scaleMat[3][1] = 0.0f;
				scaleMat[3][2] = 0.0f;
				scaleMat[3][3] = 1.0f;

				return mul(scaleMat, vertPos);
			}
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;

				o.pos = UnityObjectToClipPos(CreateOutline(v.vertex, _Outline));

				return o;
			}

			half4 frag(vertexOutput i) : COLOR
			{
				return _OutlineColor;
			}
			ENDCG
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
