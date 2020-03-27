using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCube : MonoBehaviour
{
	
	public Vector3 Position;
	public float Range = 5;

	private Vector3 pivot;
	private Material mat;
	private void Start()
	{
		mat = GetComponent<Renderer>().material;
		pivot = transform.position;
	}

	void SetPosition()
	{
		float dist = Vector3.Distance(pivot, Position);
		Vector3 move = Vector3.zero;
		if (dist < Range)
		{
			move = Vector3.Normalize(pivot - Position) * (Range - dist);
			mat.SetColor("_Color", Color.Lerp(Color.white, Color.red, (Range - dist) / Range));
		}
		else
			dist = Range;
		transform.position = pivot + move;
		//mat.SetColor("_Color",Color.Lerp(Color.white, Color.red, (Range - dist)/Range));
	}
    void Update()
    {
		SetPosition();
    }
}
