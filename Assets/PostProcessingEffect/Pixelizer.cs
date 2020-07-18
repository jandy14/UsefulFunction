using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pixelizer : MonoBehaviour
{
	private Material material;
	[Range(1,100)]
	public int pixelSize = 1;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Pixelizer"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_PixelSize", (float)pixelSize);
		Graphics.Blit(source, destination, material);
	}
}
