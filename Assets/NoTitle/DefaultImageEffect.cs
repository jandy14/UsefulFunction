using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefaultImageEffect : MonoBehaviour
{
	public Shader shader;

	[SerializeField]
	private Material mat;

	void Awake()
	{
		mat = new Material(shader);
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, mat);
	}
}
