Shader "Unlit/CRT"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_WaveFrequency ("WaveFrequency", float) = 1
		_Move ("Move",float) = 0.1
		_Noise("Noise", range(0,1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

			const float pi = 3.141592653589793238462;
			float _WaveFrequency;
			float _Amount;
			float _Move;
			float _Noise;
			float rand(float n) { return frac(sin(n) * 43758.5453123); }
			float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

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
				float2 coord = i.uv;
				fixed4 col = tex2D(_MainTex, i.uv);
				col += fixed4((rand(coord.x + _Time.y) - 0.5)*_Noise, (rand(coord.y + _Time.y) - 0.5)*_Noise, (rand(coord + _Time.y) - 0.5)*_Noise, 0);
				float strength = sin(coord.y * _WaveFrequency + _Time.y * _Move) * 0.2 + 0.5;
				col *= strength;
                return col;
            }
            ENDCG
        }
    }
}
