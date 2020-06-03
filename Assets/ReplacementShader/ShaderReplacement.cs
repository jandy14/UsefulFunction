using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderReplacement : MonoBehaviour
{
	public Shader replacementShader;
	public string tagName;

	// Start is called before the first frame update
	private void OnEnable()
	{
		GetComponent<Camera>().SetReplacementShader(replacementShader, tagName);
	}

	private void OnDisable()
	{
		GetComponent<Camera>().ResetReplacementShader();
	}
}
