Shader "Unlit/GrabPassTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Data ("Date", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		GrabPass { "_BgTex" }

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
                float4 vertex : SV_POSITION;
				float4 grabPos : TEXCOORD1;
            };

			sampler2D _BgTex;
            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Data;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
                o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed2 move = (fixed2(0.5,0.5) - i.uv) * (1 + _Data -distance(i.uv,fixed2(0.5,0.5)));
				fixed4 col = tex2Dproj(_BgTex, i.grabPos + fixed4(move, 0, 0));
				//fixed4 col = tex2D(_BgTex, (i.grabPos / i.grabPos.w).xy + move);
				col += fixed4(0.3,0.1,0.1,1);
				return col;
            }
            ENDCG
        }
    }
}
