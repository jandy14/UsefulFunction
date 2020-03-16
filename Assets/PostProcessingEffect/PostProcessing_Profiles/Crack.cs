using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Crack : MonoBehaviour
{
	private Material material;

	public Texture crackImg;
	public float threshold;
	public Vector2 ratio;
	public int amount;

	// Creates a private material used to the effect
	void Awake()
	{
		material = new Material(Shader.Find("Hidden/Crack"));
	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Threshold", threshold);
		material.SetVector("_Ratio", new Vector4(ratio.x,ratio.y));
		material.SetInt("_Amount", amount);
		material.SetTexture("_CrackImage", crackImg);
		Graphics.Blit(source, destination, material);
	}
}
