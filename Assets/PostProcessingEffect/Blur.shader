Shader "Hidden/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Amount ("Amount", float) = 2
		_Dist ("Distance", float) = 0.01
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

		//vertical
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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _Amount;
			float _Dist;
			float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = 0;
				float sum = 0;

				for (float index = -_Amount; index <= _Amount; ++index)
				{
					float power = pow(2, -abs(index));
					col += tex2D(_MainTex, i.uv + float2(0,_Dist * index)) * power;
					sum += power;
				}
				col = col / sum;
				return col;
			}
			ENDCG
		}

			//horizontal
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;
				float _Amount;
				float _Dist;
				float rand(float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = 0;
					float sum = 0;

					for (float index = -_Amount; index <= _Amount; ++index)
					{
						float power = pow(2, -abs(index));
						col += tex2D(_MainTex, i.uv + float2(_Dist * index, 0)) * power;
						sum += power;
					}
					col = col / sum;
					return col;
				}
				ENDCG
			}
    }
}
