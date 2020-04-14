using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Glitch : MonoBehaviour
{
	private Material material;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Glitch"));
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_LineAmount", 40f);
		Graphics.Blit(source, destination, material);
	}
}
