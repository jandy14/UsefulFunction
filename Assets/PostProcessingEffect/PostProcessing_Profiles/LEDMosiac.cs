using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LEDMosiac : MonoBehaviour
{
	private Material material;

	public Vector2 Amount;

	void Awake()
	{
		material = new Material(Shader.Find("Hidden/LEDMosaic"));
	}
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetVector("_Amount", new Vector4(Amount.x, Amount.y));
		Graphics.Blit(source, destination, material);
	}
}
