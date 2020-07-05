using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Reveal : TextEffect
{
	public float speed = 0.1f;

	private float timer = 0;

	private void Update()
	{
		if(isWorking)
			timer += Time.deltaTime;
	}
	public override void OneFrameWork()
	{
		TMP_TextInfo textInfo = text.textInfo;
		Color32[] newVertexColors;
		foreach(Vector2Int index in indices)
		{
			Debug.Log(timer);
			for (int i = index.x; i < index.y; ++i)
			{
				int materialIndex = textInfo.characterInfo[i].materialReferenceIndex;
				newVertexColors = textInfo.meshInfo[materialIndex].colors32;
				int vertexIndex = textInfo.characterInfo[i].vertexIndex;
				
				if(textInfo.characterInfo[i].isVisible)
				{
					if (timer > i*speed)
					{
						newVertexColors[vertexIndex + 0].a = 255;
						newVertexColors[vertexIndex + 1].a = 255;
						newVertexColors[vertexIndex + 2].a = 255;
						newVertexColors[vertexIndex + 3].a = 255;
					}
					else
					{
						newVertexColors[vertexIndex + 0].a = 0;
						newVertexColors[vertexIndex + 1].a = 0;
						newVertexColors[vertexIndex + 2].a = 0;
						newVertexColors[vertexIndex + 3].a = 0;
					}
				}
			}
		}
	}
}