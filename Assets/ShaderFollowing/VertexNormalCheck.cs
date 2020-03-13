using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexNormalCheck : MonoBehaviour
{
	public Mesh mesh;
    // Start is called before the first frame update
    void Start()
    {
		mesh = GetComponent<MeshFilter>().mesh;

		//vertex check
		Debug.Log("Vertices Count :" + mesh.vertexCount);
		foreach( Vector3 v in mesh.vertices)
		{
			Debug.Log(v);
		}
		//vertex triangle index
		Debug.Log("index Count :" + mesh.triangles.Length);
		foreach (int v in mesh.triangles)
		{
			Debug.Log(v);
		}
		//vertex normal
		Debug.Log("Normal Count :" + mesh.normals.Length);
		foreach (Vector3 v in mesh.normals)
		{
			Debug.Log(v);
		}
	}

    // Update is called once per frame
    void Update()
    {
        
    }
}
