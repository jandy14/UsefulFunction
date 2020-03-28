using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateObject : MonoBehaviour
{
	public GameObject player;
	public GameObject obj;
	public Vector3 startPos;
	public Vector3 endPos;
	public float dist;
	public bool isShader = true;

	private MoveCube[] moveCubes;
	private Material[] particles;
	void Awake()
    {
		int amount = ((int)(Mathf.Abs(endPos.x - startPos.x)/dist) + 1) * ((int)(Mathf.Abs(endPos.z - startPos.z)/dist) + 1);
		if(isShader)
			particles = new Material[amount];
		else
			moveCubes = new MoveCube[amount];
		MakeObject();
    }

	void MakeObject()
	{
		int i = 0;
		for(float x = startPos.x; x < endPos.x; x +=  dist)
		{
			for (float z = startPos.z; z < endPos.z; z += dist)
			{
				GameObject tmp = Instantiate(obj, new Vector3(x, startPos.y, z), Quaternion.identity);
				if (isShader)
					particles[i++] = tmp.GetComponent<Renderer>().material;
				else
					moveCubes[i++] = tmp.GetComponent<MoveCube>();
			}
		}
	}

	void SetPosition()
	{
		Vector3 pos = player.transform.position;
		Shader.SetGlobalVector("_Position", pos);
		//for(int i = 0; i < particles.Length; ++i)
		//{
		//	if(particles[i] != null)
		//		particles[i].SetVector("_Position", pos);
		//}
	}
	void SetScriptPosition()
	{
		Vector3 pos = player.transform.position;
		for (int i = 0; i < moveCubes.Length; ++i)
		{
			if (moveCubes[i] != null)
				moveCubes[i].Position = pos;
		}
	}
    // Update is called once per frame
    void Update()
    {
		if (isShader)
			SetPosition();
		else
			SetScriptPosition();
    }
}
