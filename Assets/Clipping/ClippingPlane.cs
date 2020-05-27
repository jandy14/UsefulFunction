using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClippingPlane : MonoBehaviour
{
	public Material mat;
    
    void Awake()
    {
    }
    void Update()
    {
		Plane plane = new Plane(transform.up, transform.position);
		Vector4 planeRepresentation = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);
		//Debug.Log(plane.distance);
		mat.SetVector("_Plane", planeRepresentation);
	}
}
