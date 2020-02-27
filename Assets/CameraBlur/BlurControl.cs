using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

public class BlurControl : MonoBehaviour
{
	public PostProcessVolume ppv;
	public Image img;
	public Image up;
	public Image down;
	public AnimationCurve curve;
	public AnimationCurve eyeCurve;
	public float time;
	public float eyeTime;

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
		Vector3 dest = Vector3.up * 1500;
		Vector3 start = up.rectTransform.localPosition;
		Debug.Log(start);
		while(timer < time)
		{
			img.material.SetFloat("_Radius", Mathf.Lerp(15, 0, curve.Evaluate(timer / time)));
			//ppv.weight = Mathf.Lerp(1, 0.6f, curve.Evaluate(timer / time));

			up.rectTransform.localPosition = Vector3.Lerp(start, dest, eyeCurve.Evaluate(timer / eyeTime));
			down.rectTransform.localPosition = Vector3.Lerp(-start, -dest, eyeCurve.Evaluate(timer / eyeTime));

			timer += Time.deltaTime;
			yield return null;
		}
		img.material.SetFloat("_Radius", 0);
	}
}
