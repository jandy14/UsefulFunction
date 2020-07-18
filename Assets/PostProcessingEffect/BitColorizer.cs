using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BitColorizer : MonoBehaviour
{
	[Range(0,256)]
	public int redPrecision = 0;
	[Range(0, 256)]
	public int greenPrecision = 1;
	[Range(0, 256)]
	public int bluePrecision = 1;
	private Material material;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/BitColorizer"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_RedPrecision", (float)redPrecision);
		material.SetFloat("_GreenPrecision", (float)greenPrecision);
		material.SetFloat("_BluePrecision", (float)bluePrecision);
		Graphics.Blit(source, destination, material);
	}
}
