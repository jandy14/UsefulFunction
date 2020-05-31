Shader "Unlit/DepthDiff"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry+1"}

        Pass
        {
			zwrite off
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
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _CameraDepthTexture;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				//1st
				o.screenPos = o.vertex;
				//2nd
				//o.screenPos = ComputeScreenPos(o.vertex);
				
				return o;
			}

			//정확한건 아니고 이런 느낌?
			// tex2Dproj(_Tex, projCoord) == tex2D(_Tex, projCoord.xy / projCoord.w)

			fixed4 frag(v2f i) : SV_Target
			{
				//1st
				float predepth = tex2D(_CameraDepthTexture, (i.screenPos / i.screenPos.w).xy * float2(1,-1) * 0.5 + 0.5 ).r;
				//2nd
				//float predepth = tex2Dproj(_CameraDepthTexture, i.screenPos).r;
				
				float depth = i.screenPos.z / i.screenPos.w;
				return depth - predepth < 0.001 ? 1 : 0;
			}
            ENDCG
        }
    }
}
