using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WhiteNoise : MonoBehaviour
{
	private Material material;
	[Range(0f,1f)]
	public float strength = 0.1f;
	// Creates a private material used to the effect
	void Awake()
	{
		material = new Material(Shader.Find("Hidden/WhiteNoise"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Strength", strength);
		Graphics.Blit(source, destination, material);
	}
}
