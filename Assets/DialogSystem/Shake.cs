using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Shake : TextEffect
{
	public override void Work()
	{
		//this code make mesh to reset, so lose all data you did before
		//text.ForceMeshUpdate();
		TMP_TextInfo textInfo = text.textInfo;
		Vector3[] vertices;
		foreach (Vector2Int index in indices)
		{
			for(int i = index.x; i < index.y; ++i)
			{
				TMP_CharacterInfo charInfo = textInfo.characterInfo[i];
				int materialIndex = charInfo.materialReferenceIndex;
				vertices = textInfo.meshInfo[materialIndex].vertices;
				int vertexIndex = charInfo.vertexIndex;

				if (!charInfo.isVisible)
					continue;

				float shakeAmount = 3;
				Vector3 shake = new Vector3(Random.Range(-shakeAmount, shakeAmount), Random.Range(-shakeAmount, shakeAmount), 0);
				vertices[vertexIndex + 0] = vertices[vertexIndex + 0] + shake;
				vertices[vertexIndex + 1] = vertices[vertexIndex + 1] + shake;
				vertices[vertexIndex + 2] = vertices[vertexIndex + 2] + shake;
				vertices[vertexIndex + 3] = vertices[vertexIndex + 3] + shake;
			}
		}
		text.UpdateVertexData();
	}
}
