Shader "Unlit/PixelFilter"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OutlineColor ("OutlineColor", Color) = (1,1,1,1)
		_BaseColor ("BaseColor", Color) = (1,1,1,1)
		_Threshold ("Threshold", float) = 0.98
    }
    SubShader
    {
		Blend SrcAlpha OneMinusSrcAlpha
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

            sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _OutlineColor;
			float4 _BaseColor;
			float _Threshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv);

				fixed4 up = tex2D(_MainTex, i.uv + fixed2(0, _MainTex_TexelSize.y));
				fixed4 down = tex2D(_MainTex, i.uv + fixed2(0, -_MainTex_TexelSize.y));
				fixed4 left = tex2D(_MainTex, i.uv + fixed2(-_MainTex_TexelSize.x, 0));
				fixed4 right = tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x, 0));

				float aup = dot(normalize(col), normalize(up));
				float adown = dot(normalize(col), normalize(down));
				float aleft = dot(normalize(col), normalize(left));
				float aright = dot(normalize(col), normalize(right));

				if (aup * adown * aleft * aright < _Threshold)
				{
					col.rgb = _OutlineColor;
				}
				else
				{
					col.rgb = _BaseColor;
					if (up.a + down.a + left.a + right.a != 0 && col.a == 0)
					{
						col = _OutlineColor;
					}
					
				}


				//float aup = length(col - up);
				//float adown = length(col - down);
				//float aleft = length(col - left);
				//float aright = length(col - right);

				//if (aup + adown + aleft + aright > _Threshold)
				//{
				//	col.rgb = _OutlineColor;
				//}
				//else
				//{
				//	col.rgb = _BaseColor;
				//}
				////col.rgb = aup + adown + aleft + aright;
				return col;
            }
            ENDCG
        }
    }
}
