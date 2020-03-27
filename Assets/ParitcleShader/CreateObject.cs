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

	private Material[] particles;
	void Awake()
    {
		int amount = ((int)(Mathf.Abs(endPos.x - startPos.x)/dist) + 1) * ((int)(Mathf.Abs(endPos.z - startPos.z)/dist) + 1);
		particles = new Material[amount];
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
				particles[i++] = tmp.GetComponent<Renderer>().material;
			}
		}
	}

	void SetPosition()
	{
		Vector3 pos = player.transform.position;
		for(int i = 0; i < particles.Length; ++i)
		{
			if(particles[i] != null)
				particles[i].SetVector("_Position", pos);
		}
	}

    // Update is called once per frame
    void Update()
    {
		SetPosition();
    }
}
