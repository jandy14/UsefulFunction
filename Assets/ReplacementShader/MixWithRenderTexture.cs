using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MixWithRenderTexture : MonoBehaviour
{
	private Material material;
	// Creates a private material used to the effect
	void Awake()
	{
		material = new Material(Shader.Find("Unlit/RenderTextureChecker"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}
