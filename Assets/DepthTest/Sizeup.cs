using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sizeup : MonoBehaviour
{
	public float speed;
	public bool reset;

    // Update is called once per frame
    void Update()
    {
		transform.localScale += Vector3.one * speed;
		if(reset)
		{
			reset = false;
			transform.localScale = Vector3.zero;
		}
    }
}
