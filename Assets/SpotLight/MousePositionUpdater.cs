using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePositionUpdater : MonoBehaviour
{

    // Update is called once per frame
    void Update()
    {
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		RaycastHit hitData;

		if (Physics.Raycast(ray, out hitData, 1000))
		{
			//Debug.Log(hitData.point);
			Shader.SetGlobalVector("_MousePosition", hitData.point);
		}
	}
}
