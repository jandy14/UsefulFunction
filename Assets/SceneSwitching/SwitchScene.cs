using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchScene : MonoBehaviour
{
	private Material material;
	public Texture2D texture;
	public float threshold = 0;
	// Creates a private material used to the effect
	void Awake()
	{
		material = new Material(Shader.Find("Hidden/SwitchSceneUsingTexture"));
		material.SetTexture("_ThresholdTex", texture);
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Threshold", threshold);
		Graphics.Blit(source, destination, material);
	}
}