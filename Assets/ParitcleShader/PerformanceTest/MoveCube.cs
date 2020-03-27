using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCube : MonoBehaviour
{
	
	public Vector3 Position;
	public float Range = 5;

	private Vector3 pivot;

	private void Start()
	{
		pivot = transform.position;
	}

	void SetPosition()
	{
		float dist = Vector3.Distance(pivot, Position);
		Vector3 move = Vector3.zero;
		if(dist < Range)
			move = Vector3.Normalize(pivot - Position) * (Range - dist);
		transform.position = pivot + move;
	}
    void Update()
    {
		SetPosition();
    }
}
