using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchScene : MonoBehaviour
{
	private Material material;
	public Texture2D texture;
	public string sceneName = "";
	public float switchTime = 3;
	public AnimationCurve curve;

	float threshold = 0;

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

	private void Start()
	{
		Invoke("StartSwitching",1);
	}

	void StartSwitching()
	{
		StartCoroutine(StartSwitch());
	}

	IEnumerator StartSwitch()
	{
		float timer = 0;
		threshold = 0;
		material.SetFloat("_Invert", 0);

		while (true)
		{
			timer += Time.deltaTime;
			threshold = curve.Evaluate(timer / (switchTime / 2));

			if (timer > switchTime/2)
				break;
			yield return null;
		}

		//scene change
		threshold = 0;
		material.SetFloat("_Invert", 1);
		yield return null;

		while (true)
		{
			timer += Time.deltaTime;

			threshold = curve.Evaluate(timer / (switchTime / 2) - 1);

			if (timer > switchTime)
				break;
			yield return null;
		}

		threshold = 1;
		yield return null;
	}

}