using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Disappear : MonoBehaviour
{
	public Renderer rd;
	private void Start()
	{
		rd = GetComponent<Renderer>();
	}
	// Update is called once per frame
	void Update()
    {
		rd.material.SetFloat("_Threshold", Mathf.Sin(Time.time) * 0.5f + 0.5f );
    }
}
