using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Patrol : MonoBehaviour
{
	public Vector3 startPos;
	public Vector3 endPos;
	public AnimationCurve speed;
	public float time;

	private float timer;

	// Start is called before the first frame update
	void Start()
    {
		timer = 0;
    }

    // Update is called once per frame
    void Update()
    {
		float ratio = timer / time;

		transform.position = startPos + (endPos - startPos) * speed.Evaluate(ratio);

		timer += Time.deltaTime;
		if (timer > time)
			timer = 0;
    }
}
