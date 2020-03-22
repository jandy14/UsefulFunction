using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PixelEdgeFilter : MonoBehaviour
{
	private Material material;

	public Color BaseColor;
	public Color EdgeColor;
	public float Threshold;

	void Awake()
	{
		material = new Material(Shader.Find("Unlit/PixelFilter"));
	}
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetColor("_BaseColor", BaseColor);
		material.SetColor("_OutlineColor", EdgeColor);
		material.SetFloat("_Threshold", Threshold);
		Graphics.Blit(source, destination, material);
	}
}
