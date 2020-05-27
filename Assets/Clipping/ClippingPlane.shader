Shader "Custom/ClippingPlane"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		[HDR]_InnerColor ("Inner Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
		cull off
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldPos;
			float facing : VFACE;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
		fixed4 _InnerColor;
		float4 _Plane;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			o.Albedo = _Color;
			float distance = dot(IN.worldPos, _Plane.xyz);
			//o.Emission = distance + _Plane.w;
			clip(distance + _Plane.w);

			float facing = IN.facing * 0.5 + 0.5;

			fixed4 col = tex2D(_MainTex, IN.uv_MainTex);
			col *= _Color;
			o.Albedo = col.rgb * facing;
			o.Metallic = _Metallic * facing;
			o.Emission = lerp(_InnerColor, 0.1, facing);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
