using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ForceFieldInteract : MonoBehaviour
{
	public AnimationCurve effectCurve;
	public Material mat;

	float timer = 0;
	Vector3 pos;
    // Start is called before the first frame update
    void Start()
    {
        
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
					pos = hit.point;
					timer = 0;
					mat.SetVector("_HittedPos", new Vector4(pos.x, pos.y, pos.z, effectCurve.Evaluate(timer)));
				}
			}
		}

		timer += Time.deltaTime;
		mat.SetVector("_HittedPos", new Vector4(pos.x, pos.y, pos.z, effectCurve.Evaluate(timer)));
    }

}
