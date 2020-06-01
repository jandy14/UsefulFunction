// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ForceField"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Threshold("Threshold", float) = 0.3
		_Interact("Interact", float) = 0.1
		_Noise("Noise", float) = 0.2
	}
		SubShader
		{
			Tags { "RenderType" = "Transparent" "Queue" = "TransParent"}

			Pass
			{
				Zwrite Off
				Cull off
				Blend SrcAlpha OneMinusSrcAlpha

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float2 uv : TEXCOORD0;
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float rim : TEXCOORD1;
					float4 worldPos : TEXCOORD2;
					float4 clipPos : TEXCOORD3;
				};

				sampler2D _CameraDepthTexture;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _Threshold;
				float _Interact;
				float _Noise;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.rim = dot(v.normal, normalize(ObjSpaceViewDir(v.vertex)));
					o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
					o.clipPos = UnityObjectToClipPos(v.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 noise = tex2D(_MainTex, i.uv + _Time.x);
					float rim = step(abs(i.rim), _Threshold + noise.x * _Noise);
					float depth = tex2D(_CameraDepthTexture, i.clipPos.xy / i.clipPos.w * float4(0.5, -0.5, 1, 1) + float4(0.5, 0.5, 0, 0)).r;
					float diff = i.clipPos.w - LinearEyeDepth(depth);
					float inter = step(_Interact, abs(diff) + noise.x * _Noise) * -1 + 1;
					fixed4 col = fixed4(1, 0, 0, saturate(0.1 + 0.1 * frac(i.worldPos.y * 10 + _Time.y) + rim + inter));
					return col;
				}
				ENDCG
			}
		}
}
