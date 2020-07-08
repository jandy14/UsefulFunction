using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Wave : TextEffect
{
	public AnimationCurve waveCurve;
	public float gap = 0.1f;
	private float timer = 0;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if(isWorking)
		{
			timer += Time.deltaTime;
		}
    }
	public override void ResetEffect()
	{
		base.ResetEffect();
		timer = 0;
	}
	public override void OneFrameWork()
	{
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

				Vector3 offset = new Vector3(0, waveCurve.Evaluate(timer + i * gap), 0);
				vertices[vertexIndex + 0] = vertices[vertexIndex + 0] + offset;
				vertices[vertexIndex + 1] = vertices[vertexIndex + 1] + offset;
				vertices[vertexIndex + 2] = vertices[vertexIndex + 2] + offset;
				vertices[vertexIndex + 3] = vertices[vertexIndex + 3] + offset;
			}
		}
	}
}
