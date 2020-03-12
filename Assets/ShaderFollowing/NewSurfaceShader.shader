Shader "Custom/NewSurfaceShader"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,0.5)
	}
	SubShader
	{
		Pass
		{
			Material
			{
				Diffuse[_Color]
				Ambient (1,1,1,1)
			}
			Lighting On
		}
	}
	FallBack "Diffuse"
}