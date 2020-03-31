using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Explosion : MonoBehaviour
{
	public float time = 1;
	public float scale = 1.5f;
	public float yScale = 2f;
	public float up = 1f;
	private Material mat;
	// Start is called before the first frame update
	private void Awake()
	{
		mat = GetComponent<Renderer>().material;
	}
	void Start()
    {
		StartCoroutine(StartExplosion());
    }
	IEnumerator StartExplosion()
	{
		yield return new WaitForSeconds(1);
		float timer = 0;
		Color origColor = mat.GetColor("_Color");
		Vector3 origScale = transform.localScale;
		Vector3 origPos = transform.position;

		while(timer < time)
		{
			mat.SetFloat("_Size", Mathf.Lerp(1, 0, timer / time));
			mat.SetColor("_Color", Color.Lerp(origColor,Color.black,timer/time));
			transform.localScale = new Vector3( Mathf.Lerp(1, scale, timer / time) * origScale.x, Mathf.Lerp(1, yScale, timer / time) * origScale.y, Mathf.Lerp(1, scale, timer / time) * origScale.z);
			transform.position = origPos + Vector3.up * Mathf.Lerp(0, up, timer / time);
			timer += Time.deltaTime;
			yield return null;
		}
		mat.SetFloat("_Size", 0);
		transform.localScale = origScale * scale;
		yield return null;
	}
}
