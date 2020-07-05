using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public abstract class TextEffect : MonoBehaviour
{
	public TMP_Text text;
	public List<Vector2Int> indices;

	protected void Awake()
	{
		indices = new List<Vector2Int>();
	}
	public void AddIndex(int pStart, int pEnd)
	{
		AddIndex(new Vector2Int(pStart, pEnd));
	}
	public void AddIndex(Vector2Int pIndex)
	{
		indices.Add(pIndex);
	}
	public void SetText(TMP_Text pText)
	{
		text = pText;
	}
	public void ResetIndices()
	{
		indices.Clear();
	}
	public abstract void Work();
}
