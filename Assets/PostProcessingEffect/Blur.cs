using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Blur : MonoBehaviour
{
	private Material material;

	public float Amount = 30f;
	public float Dist = 0.05f;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Blur"));
	}
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Amount", Amount);
		material.SetFloat("_Dist", Dist);

		RenderTexture temp = RenderTexture.GetTemporary(source.width, source.height);
		for(int i = 0; i < 4; ++i)
		{
			Graphics.Blit(source, temp, material, 0);
			Graphics.Blit(temp, source, material, 1);
		}
		Graphics.Blit(source, temp, material, 0);
		Graphics.Blit(temp, destination, material, 1);
		RenderTexture.ReleaseTemporary(temp);
		//temp.Release();
	}
}
