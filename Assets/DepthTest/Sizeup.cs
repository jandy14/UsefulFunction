using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sizeup : MonoBehaviour
{
	public float speed;

    // Update is called once per frame
    void Update()
    {
		transform.localScale += Vector3.one * speed;
    }
}
