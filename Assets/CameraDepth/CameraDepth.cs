using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraDepth : MonoBehaviour
{
	private Material material;
	public float Distance = 0;
	// Creates a private material used to the effect
	void Awake()
	{
		material = new Material(Shader.Find("Hidden/CameraDepth"));
	}

	private void Update()
	{
		Distance += 0.001f;
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Distance", Distance);
		Graphics.Blit(source, destination, material);
	}
}

