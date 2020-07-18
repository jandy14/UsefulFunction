using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Post3bit : MonoBehaviour
{
	private Material material;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/3bit"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}
