using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShockwaveLoop : MonoBehaviour
{
	public float MaxDist = 1200f;
	public float LoopTime = 5f;

	private float _timer = 0;
	private Renderer _renderer;
	private Material _mat;
	private void Start()
	{
		_timer = 0;
		_mat = GetComponent<Renderer>().material;
	}

	private void Update()
	{
		_timer += Time.deltaTime;
		if (_timer > LoopTime)
		{
			_timer = 0;
		}
		float dist = MaxDist * (_timer / LoopTime);
		_mat.SetFloat("_Distance", dist);
	}
}
