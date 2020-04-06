Shader "Hidden/2DSpotlight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Distance("Distance", float) = 20
		_Edge ("Edge", float) = 10
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
			float4 _MousePosition;
			float _Distance;
			float _Edge;
            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv);
				float2 coord = i.uv * _ScreenParams.xy;
				float blend = (clamp(distance(coord, _MousePosition), _Edge, _Distance) - _Edge) / (_Distance - _Edge);
				col *= (1 - blend);
                return col;
            }
            ENDCG
        }
    }
}
