using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
	public float speed = 1;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
		Vector3 move = Vector3.zero;
		move.x += Input.GetAxis("Horizontal");
		move.z += Input.GetAxis("Vertical");
		
		if (move.magnitude > 0.1f)
		{
			move.Normalize();
			move *= speed;
		}
		else { move = Vector3.zero; }
		transform.position += move;
	}
}
