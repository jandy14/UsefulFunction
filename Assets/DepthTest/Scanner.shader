Shader "Unlit/Scanner"
{
    Properties
    {
		_Color ("Color", Color) = (1,1,1,1)
		_Diff ("Depth Diff", float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "TransParent" }
        LOD 100

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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 clipPos : TEXCOORD1;
            };

			sampler2D _CameraDepthTexture;
			fixed4 _Color;
			float _Diff;

            v2f vert (appdata v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.clipPos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = _Color;
				float depth = tex2D(_CameraDepthTexture, i.clipPos.xy / i.clipPos.w * float4(0.5, -0.5, 1, 1) + float4(0.5, 0.5, 0, 0)).r;
				float diff = i.clipPos.w - LinearEyeDepth(depth);
				float alpha = step(_Diff, abs(diff)) * -1 + 1;
				return fixed4(col.rgb, alpha);
            }
            ENDCG
        }
    }
}
