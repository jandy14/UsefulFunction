using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class RevealWithAnimation : TextEffect
{
	public float speed = 0.1f;
	public float animationSpeed = 0.1f;
	public float fadeInSpeed = 0.1f;
	public float animationDistance = 5;

	private float timer = 0;

	private void Update()
	{
		if (isWorking)
			timer += Time.deltaTime;
	}
	public override void OneFrameWork()
	{
		TMP_TextInfo textInfo = text.textInfo;
		Color32[] newVertexColors;
		Vector3[] vertices;
		Vector3 offset = new Vector3(0,0,0);

		foreach (TagInfo info in tagInfos)
		{
			for (int i = info.startIndex; i < info.endIndex; ++i)
			{
				int materialIndex = textInfo.characterInfo[i].materialReferenceIndex;
				newVertexColors = textInfo.meshInfo[materialIndex].colors32;
				vertices = textInfo.meshInfo[materialIndex].vertices;
				int vertexIndex = textInfo.characterInfo[i].vertexIndex;

				if (textInfo.characterInfo[i].isVisible)
				{
					if (timer > i * speed)
					{
						newVertexColors[vertexIndex + 0].a = (byte)Mathf.Lerp(0, 255, (timer - i * speed) / fadeInSpeed);
						newVertexColors[vertexIndex + 1].a = (byte)Mathf.Lerp(0, 255, (timer - i * speed) / fadeInSpeed);
						newVertexColors[vertexIndex + 2].a = (byte)Mathf.Lerp(0, 255, (timer - i * speed) / fadeInSpeed);
						newVertexColors[vertexIndex + 3].a = (byte)Mathf.Lerp(0, 255, (timer - i * speed) / fadeInSpeed);
						offset.y = Mathf.Lerp(animationDistance, 0, (timer - i * speed) / animationSpeed);
						vertices[vertexIndex + 0] = vertices[vertexIndex + 0] + offset;
						vertices[vertexIndex + 1] = vertices[vertexIndex + 1] + offset;
						vertices[vertexIndex + 2] = vertices[vertexIndex + 2] + offset;
						vertices[vertexIndex + 3] = vertices[vertexIndex + 3] + offset;
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
