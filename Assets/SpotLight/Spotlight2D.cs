using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spotlight2D : MonoBehaviour
{
	public float distance = 20f;
	public float edge = 10f;
	private Material material;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/2DSpotlight"));
	}

	private void Update()
	{
		Debug.Log(Input.mousePosition);
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Shader.SetGlobalVector("_MousePosition", Input.mousePosition);
		material.SetFloat("_Distance", distance);
		material.SetFloat("_Edge", edge);
		Graphics.Blit(source, destination, material);
	}
}
