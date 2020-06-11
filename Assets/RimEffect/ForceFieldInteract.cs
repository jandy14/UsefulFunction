using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ForceFieldInteract : MonoBehaviour
{
	public AnimationCurve effectCurve;
	public Material mat;
	[Range(1,20)]
	public int MaxParticle;
	float timer = 0;
	List<Vector4> pos;

	int posArrayLength;
	Vector4[] posArray;
    // Start is called before the first frame update
    void Start()
    {
		pos = new List<Vector4>();
		posArray = new Vector4[20];
		for(int i = 0; i < posArray.Length; ++i)
		{
			posArray[i] = new Vector4();
		}
    }

    // Update is called once per frame
    void Update()
    {
		if (Input.GetMouseButtonDown(0))
		{
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			RaycastHit hit;
			if (Physics.Raycast(ray, out hit, Mathf.Infinity))
			{
				if (hit.transform.gameObject == gameObject)
				{
					pos.Add(new Vector4(hit.point.x, hit.point.y, hit.point.z, timer));
				}
			}
		}

		timer += Time.deltaTime;
		
		SetPosArray();

		mat.SetInt("_HittedPosSize", posArrayLength);
		mat.SetVectorArray("_HittedPosArray", posArray);
	}
	void SetPosArray()
	{
		float endTime = effectCurve.keys[effectCurve.length - 1].time;
		int index = 0;
		for (int i = pos.Count - 1; i >= 0; i--)
		{
			float time = timer - pos[i].w;
			if (time > endTime)
			{
				pos.RemoveAt(i);
				continue;
			}
			posArray[index].x = pos[i].x;
			posArray[index].y = pos[i].y;
			posArray[index].z = pos[i].z;
			posArray[index].w = effectCurve.Evaluate(time);
			index++;
			if (index >= MaxParticle) break;
		}
		posArrayLength = index;
	}
}
