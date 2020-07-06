using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Shake : TextEffect
{
	public float time = 0.01f;
	public float shakeAmount = 3;
	private float timer = 0;
	private Vector3 shake;
	private void Update()
	{
		if(isWorking)
		{
			timer += Time.deltaTime;
			if (timer > time)
			{
				shake = new Vector3(Random.Range(-shakeAmount, shakeAmount), Random.Range(-shakeAmount, shakeAmount), 0);
				timer -= time;
			}
		}
	}
	public override void ResetEffect()
	{
		base.ResetEffect();
		shake = Vector3.zero;
		timer = 0;
	}
	public override void OneFrameWork()
	{
		//this code make mesh to reset, so lose all data you did before. i guess..
		//text.ForceMeshUpdate();
		TMP_TextInfo textInfo = text.textInfo;
		Vector3[] vertices;
		foreach (TagInfo info in tagInfos)
		{
			for (int i = info.startIndex; i < info.endIndex; ++i)
			{
				TMP_CharacterInfo charInfo = textInfo.characterInfo[i];
				int materialIndex = charInfo.materialReferenceIndex;
				vertices = textInfo.meshInfo[materialIndex].vertices;
				int vertexIndex = charInfo.vertexIndex;

				if (!charInfo.isVisible)
					continue;

				//float shakeAmount = 3;
				Vector3 shake = new Vector3(Random.Range(-shakeAmount, shakeAmount), Random.Range(-shakeAmount, shakeAmount), 0);
				vertices[vertexIndex + 0] = vertices[vertexIndex + 0] + shake;
				vertices[vertexIndex + 1] = vertices[vertexIndex + 1] + shake;
				vertices[vertexIndex + 2] = vertices[vertexIndex + 2] + shake;
				vertices[vertexIndex + 3] = vertices[vertexIndex + 3] + shake;
			}
		}
	}
}
