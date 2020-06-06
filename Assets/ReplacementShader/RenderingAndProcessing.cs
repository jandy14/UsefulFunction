using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderingAndProcessing : MonoBehaviour
{
	[Range(0,10)]
	public int loop = 1;
	public float amount = 0.1f;
	public Shader baseShader;

	private static RenderTexture baseImg;
	private static RenderTexture madeImg;

	private Material mat;

	private void OnEnable()
	{
		Camera camera = GetComponent<Camera>();
		baseImg = new RenderTexture(Screen.width, Screen.height, 24);
		madeImg = new RenderTexture(Screen.width, Screen.height, 0);
		camera.targetTexture = baseImg;
		camera.SetReplacementShader(baseShader, "Glowable");
		Shader.SetGlobalTexture("_BaseImg", baseImg);
		Shader.SetGlobalTexture("_MadeImg", madeImg);

		mat = new Material(Shader.Find("Hidden/Extend"));
		//mat.SetFloat("_Amount", 30f);
		//mat.SetFloat("_Dist", 0.002f);
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination);

		for (int i = 0; i < loop; ++i)
		{
			Graphics.Blit(source, madeImg, mat);
			Graphics.Blit(madeImg, source, mat);
		}
		Graphics.Blit(source, madeImg, mat);
	}
}
