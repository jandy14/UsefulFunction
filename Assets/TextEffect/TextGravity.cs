using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TextGravity : MonoBehaviour
{
	public TMP_Text text;
	public GameObject collider;

	private TMP_TextInfo textInfo;
	private GameObject[] colliders;
	private Vector3[] _newVertise;

	// Start is called before the first frame update
	void Start()
    {
		text.ForceMeshUpdate();
		textInfo = text.textInfo;
		Debug.Log(textInfo.meshInfo[0].vertices);
		_newVertise = new Vector3[textInfo.meshInfo[0].vertices.Length];
		MakeCollider();
		SetCollider();
    }

	void SetCollider()
	{
		text.ForceMeshUpdate();
		Vector3[] vertices = textInfo.meshInfo[0].vertices;
		int characterCount = textInfo.characterCount;

		if (colliders.Length != characterCount)
		{
			MakeCollider();
		}

		for (int i = 0; i < characterCount; ++i)
		{
			TMP_CharacterInfo charInfo = textInfo.characterInfo[i];
			int vertexIndex = charInfo.vertexIndex;

			//if (!charInfo.isVisible)
			//	continue;

			Vector2[] box = new Vector2[4];
			box[0] = vertices[vertexIndex + 0];
			box[1] = vertices[vertexIndex + 1];
			box[2] = vertices[vertexIndex + 2];
			box[3] = vertices[vertexIndex + 3];

			colliders[i].transform.position = (box[0] + box[1] + box[2] + box[3]) / 4;
			colliders[i].GetComponent<BoxCollider2D>().size = new Vector2(Mathf.Abs(box[1].x - box[2].x), Mathf.Abs(box[0].y - box[1].y));
		}
	}
	void MakeCollider()
	{
		text.ForceMeshUpdate();
		int characterCount = textInfo.characterCount;
		colliders = new GameObject[characterCount];
		for (int i = 0; i < characterCount; ++i)
		{
			colliders[i] = Instantiate(collider);
			//colliders[i].SetActive(textInfo.characterInfo[i].isVisible);
		}
	}

	// Update is called once per frame
	void Update()
    {
		SyncToText();
    }
	void SyncToText()
	{
		text.ForceMeshUpdate();
		int characterCount = textInfo.characterCount;

		for (int i = 0; i < characterCount; ++i)
		{
			TMP_CharacterInfo charInfo = textInfo.characterInfo[i];
			int vertexIndex = charInfo.vertexIndex;

			Vector2 size = colliders[i].GetComponent<BoxCollider2D>().size;

			float[] x = new float[] { -size.x / 2, -size.x / 2, size.x / 2, size.x / 2 };
			float[] y = new float[] { -size.y / 2, size.y / 2, size.y / 2, -size.y / 2 };

			for (int j = 0; j < 4; ++j)
			{
				Vector2 point = RotatePointAroundPivot(new Vector3(x[j], y[j]), Vector3.zero, colliders[i].transform.eulerAngles);
				_newVertise[vertexIndex + j] = (Vector2)colliders[i].transform.position + point;
			}
		}

		for (int i = 0; i < textInfo.meshInfo.Length; i++)
		{
			textInfo.meshInfo[i].mesh.vertices = _newVertise;
			text.UpdateGeometry(textInfo.meshInfo[i].mesh, i);
		}
	}
	Vector3 RotatePointAroundPivot(Vector3 point, Vector3 pivot, Vector3 angles)
	{
		Vector3 dir = point - pivot; // get point direction relative to pivot
		dir = Quaternion.Euler(angles) * dir; // rotate it
		point = dir + pivot; // calculate rotated point
		return point; // return it
	}
}
