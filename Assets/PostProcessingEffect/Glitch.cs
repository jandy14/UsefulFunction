using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Glitch : MonoBehaviour
{
	private Material material;
	public float LineAmount = 40f;
	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Glitch"));
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_LineAmount", LineAmount);
		Graphics.Blit(source, destination, material);
	}
}
