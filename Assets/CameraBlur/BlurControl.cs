using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

public class BlurControl : MonoBehaviour
{
	public PostProcessVolume ppv;
	public Image img;
	public AnimationCurve curve;
	public float time;

	// Start is called before the first frame update
	void Start()
	{
		img.material.SetFloat("_Radius", 15);
		StartCoroutine(WakeUp());
	}

	// Update is called once per frame
	void Update()
	{

	}
	IEnumerator WakeUp()
	{
		yield return new WaitForSeconds(1f);
		float timer = 0;

		while(timer < time)
		{
			Debug.Log(Mathf.Lerp(5, 0, curve.Evaluate(timer / time)));
			img.material.SetFloat("_Radius", Mathf.Lerp(15, 0, curve.Evaluate(timer / time)));
			//ppv.weight = Mathf.Lerp(1, 0.6f, curve.Evaluate(timer / time));
			timer += Time.deltaTime;
			yield return null;
		}
		img.material.SetFloat("_Radius", 0);
	}
}
