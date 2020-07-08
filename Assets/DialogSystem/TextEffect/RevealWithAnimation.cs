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
	private float[] revealTime;

	private void Update()
	{
		//Debug.Log(timer.ToString() + ":" + isWorking.ToString());
		if (isWorking)
		{
			timer += Time.deltaTime;
			if (timer > revealTime[revealTime.Length - 1] + Mathf.Max(animationSpeed, fadeInSpeed))
			{
				isFinished = true;
				isWorking = false;
			}
		}
	}
	
	public override void AddInfo(TagInfo pTagInfo)
	{
		base.AddInfo(pTagInfo);
		if(revealTime == null || revealTime.Length != text.textInfo.characterCount)
		{
			revealTime = new float[text.textInfo.characterCount];
			System.Array.Clear(revealTime, 0, revealTime.Length);
		}
		int stack = 1;
		float addTime;
		if (pTagInfo.values != null && pTagInfo.values["reveal"] != null)
			addTime = float.Parse(pTagInfo.values["reveal"]);
		else
			addTime = speed;

		for (int i = pTagInfo.startIndex; i < text.textInfo.characterCount; ++i)
		{
			revealTime[i] += addTime * stack;
			if(i < pTagInfo.endIndex)
				stack++;
		}
	}
	public override void ResetEffect()
	{
		base.ResetEffect();
		revealTime = null;
		isFinished = false;
		timer = 0;
	}
	public override void SkipToTheEnd()
	{
		base.SkipToTheEnd();
		timer = revealTime[revealTime.Length - 1] + animationSpeed + fadeInSpeed;
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
					if (timer > revealTime[i])
					{
						float alpha = (timer - revealTime[i]) / fadeInSpeed;
						offset.y = Mathf.Lerp(animationDistance, 0, (timer - revealTime[i]) / animationSpeed);
						for (int j = 0; j < 4; ++j)
						{
							newVertexColors[vertexIndex + j].a = (byte)Mathf.Lerp(0, 255, alpha);
							vertices[vertexIndex + j] = vertices[vertexIndex + j] + offset;
						}
					}
					else
					{
						for (int j = 0; j < 4; ++j)
						{
							newVertexColors[vertexIndex + j].a = 0;
						}
					}
				}
			}
		}
	}
}
