using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateMesh : MonoBehaviour
{
	public GameObject player;

	public Vector3 startPos;
	public Vector3 endPos;
	public float dist;

	public Material mat;

	private Material _mat;
	// Start is called before the first frame update
	private void Awake()
	{
		MakeObject();
	}

	void MakeObject()
	{
		GameObject obj = new GameObject();
		Mesh mesh = obj.AddComponent<MeshFilter>().mesh;
		obj.AddComponent<MeshRenderer>().material = mat;
		_mat = obj.GetComponent<MeshRenderer>().material;
		int amount = ((int)(Mathf.Abs(endPos.x - startPos.x) / dist) + 1) * ((int)(Mathf.Abs(endPos.z - startPos.z) / dist) + 1);
		Vector3[] vertices = new Vector3[amount];
		int[] triangles = new int[amount * 3];
		int i = 0;
		int w = 0;
		int y = 0;
		for (float x = startPos.x; x <= endPos.x; x += dist)
		{
			y = 0;
			for (float z = startPos.z; z <= endPos.z; z += dist)
			{
				vertices[i] = new Vector3(x, startPos.y, z);
				triangles[i * 3 + 0] = i;
				triangles[i * 3 + 1] = i;
				triangles[i * 3 + 2] = i;
				++i;
				++y;
			}
			++w;
		}
		Debug.Log(amount);
		Debug.Log(((int)(Mathf.Abs(endPos.x - startPos.x) / dist) + 1));
		Debug.Log(((int)(Mathf.Abs(endPos.z - startPos.z) / dist) + 1));
		Debug.Log(i);
		Debug.Log(w);
		Debug.Log(y);
		mesh.vertices = vertices;
		mesh.triangles = triangles;

	}
	void SetPosition()
	{
		Shader.SetGlobalVector("_Position", player.transform.position);
	}
    void Update()
    {
		SetPosition();
    }
}
