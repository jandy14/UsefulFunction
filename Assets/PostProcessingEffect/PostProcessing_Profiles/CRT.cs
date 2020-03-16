using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CRT : MonoBehaviour
{
	private Material material;

	[Range(0,1)]
	public float noise = 0.1f;
	public float move = 0.1f;
	public float waveFrequency = 1f;

	// Creates a private material used to the effect
	void Awake()
	{
		material = new Material(Shader.Find("Hidden/CRT"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_WaveFrequency", waveFrequency);
		material.SetFloat("_Move", move);
		material.SetFloat("_Noise", noise);
		Graphics.Blit(source, destination, material);
	}
}
