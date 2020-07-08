using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GradientEffect : TextEffect
{
	public Gradient gradient;
	public float loopTime;
	public float gap;

	private float timer;

    void Update()
    {
        if(isWorking)
		{
			timer += Time.deltaTime;
		}
    }
	public override void OneFrameWork()
	{
		if(isWorking)
		{
			TMP_TextInfo textInfo = text.textInfo;
			Color32[] newVertexColors;
			Vector3 offset = new Vector3(0, 0, 0);

			foreach (TagInfo info in tagInfos)
			{
				for (int i = info.startIndex; i < info.endIndex; ++i)
				{
					int materialIndex = textInfo.characterInfo[i].materialReferenceIndex;
					newVertexColors = textInfo.meshInfo[materialIndex].colors32;
					int vertexIndex = textInfo.characterInfo[i].vertexIndex;

					if (textInfo.characterInfo[i].isVisible)
					{
						Color32 value = gradient.Evaluate(((i * gap + timer) / loopTime) % 1);
						for(int j = 0; j < 4; ++j)
						{
							newVertexColors[vertexIndex + j].r = value.r;
							newVertexColors[vertexIndex + j].g = value.g;
							newVertexColors[vertexIndex + j].b = value.b;
						}
					}
				}
			}
		}
	}
}
