using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour
{
	public List<Material> mats;
	public float switchTime = 4f;
	public float maxDistance = 20;
	public Color switchColor1;
	public Color switchColor2;
	public GameObject particle;

	void Start()
    {
		StartCoroutine(SwitchColor());
    }

	IEnumerator SwitchColor()
	{
		particle.SetActive(true);
		ParticleSystem.ShapeModule shape = particle.GetComponent<ParticleSystem>().shape;
		shape.radius = 0;
		yield return new WaitForSeconds(2f);

		float dist = 0;
		float timer = 0;

		foreach (Material m in mats)
		{
			m.SetColor("_MainColor3", switchColor1);
			m.SetColor("_MainColor4", switchColor2);
		}

		while (true)
		{
			timer += Time.deltaTime;
			dist = Mathf.Lerp(0, maxDistance, timer / switchTime);
			shape.radius = dist;
			foreach(Material m in mats)
			{
				m.SetFloat("_Dist", dist);
			}

			if (timer > switchTime)
				break;
			yield return null;
		}

		particle.SetActive(false);
		foreach (Material m in mats)
		{
			m.SetColor("_MainColor1", switchColor1);
			m.SetColor("_MainColor2", switchColor2);
			m.SetFloat("_Dist", 0);
		}

		yield return null;
	}
}
