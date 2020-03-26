using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scaler : MonoBehaviour
{
	public float scale = 1f;
	private void Update()
	{
		transform.localScale = new Vector3(scale,scale,scale);
	}
}
