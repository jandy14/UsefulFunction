using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UseCurve : MonoBehaviour
{
	private Vector3 startPos;
	public float time;
	public Vector3 targetPos;
	public AnimationCurve curve;
	// Start is called before the first frame update
	void Start()
    {
		Debug.Log(curve.length);
		Debug.Log(curve.keys[1].weightedMode);
		Debug.Log(curve.Evaluate(0));
		Debug.Log(curve.Evaluate(0.1f));
		Debug.Log(curve.Evaluate(0.85f));
		Debug.Log(curve.Evaluate(1f));
		Debug.Log(curve.Evaluate(2f));

		StartCoroutine(Move());
	}

    // Update is called once per frame
    void Update()
    {
		
	}
	IEnumerator Move()
	{
		yield return new WaitForSeconds(1f);
		startPos = transform.position;
		float timer = 0;
		while (timer < time)
		{
			transform.position = startPos + (targetPos - startPos) * curve.Evaluate(timer / time);
			timer += Time.deltaTime;
			yield return null;
		}
		transform.position = targetPos;
	}
}
