using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Blur : MonoBehaviour
{
	private Material material;

	public float Amount;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Blur"));
	}
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Amount", Amount);
		Graphics.Blit(source, destination, material);
	}
}
