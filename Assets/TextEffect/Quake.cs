using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Quake : MonoBehaviour
{
	public float power;
	public float torque;
    // Start is called before the first frame update
    void Start()
    {
		GetComponent<Rigidbody2D>().AddForce(new Vector2(Random.Range(-power,power), Random.Range(-1f,power)));
		GetComponent<Rigidbody2D>().AddTorque( Random.Range(-torque, torque) );
	}

    // Update is called once per frame
    void Update()
    {
        
    }
}
