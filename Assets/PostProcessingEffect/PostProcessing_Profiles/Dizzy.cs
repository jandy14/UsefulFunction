using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dizzy : MonoBehaviour
{
	private Material material;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Dizzy"));
	}
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}
