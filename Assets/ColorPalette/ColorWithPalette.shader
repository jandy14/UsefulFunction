Shader "Unlit/ColorWithPalette"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ColorPalette("Color Palette", 2D) = "white" {}
		_ColorAmount("Amount of Color", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 100
        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _ColorPalette;
			float _ColorAmount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 answer = col;
				answer.a = 1;
				float min = 3;
				for (float i = 0; i < _ColorAmount-0.1; i += 1)
				{
					fixed4 palette = tex2D(_ColorPalette, float2((i + 0.5)/_ColorAmount, 0.5));
					float dist = distance(col, palette);
					if (min > dist)
					{
						answer = palette;
						min = dist;
					}
				}
				answer.a = col.a;
                return answer;
            }
            ENDCG
        }
    }
}
