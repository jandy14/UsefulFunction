using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TextShack : MonoBehaviour
{
	public TMP_Text text;
	public AnimationCurve colorCurve;
	public AnimationCurve waveCurve;
	public float colorTime;
	public float waveTime;
	public float shakeAmount;
	public bool isOver = false;
	public bool go = false;
	
	private Vector3[] _origVertices;
	private float[] _prevTimer;

    // Start is called before the first frame update
    void Start()
    {
		Debug.Log(text.textInfo.characterCount);
		Debug.Log(text.textInfo.characterInfo);
		Debug.Log(text.textInfo.linkInfo.Length);
		for(int i = 0; i < text.textInfo.linkInfo.Length; ++i)
		{

			Debug.Log(text.textInfo.linkInfo[i]);
		}
	}

    // Update is called once per frame
    void Update()
    {
		if(go)
		{
			go = false;
			StartCoroutine(Shake());
		}
	}
	IEnumerator Shake()
	{
		text.ForceMeshUpdate();
		TMP_TextInfo textInfo = text.textInfo;
		_prevTimer = new float[textInfo.characterCount];
		for(int i = 0; i < _prevTimer.Length; ++i)
		{
			_prevTimer[i] = i * 0.05f;
		}
		TMP_MeshInfo[] cachedMeshInfo = textInfo.CopyMeshInfoVertexData();
		
		_origVertices = textInfo.meshInfo[0].vertices;

		while (true)
		{
			int characterCount = textInfo.characterCount;
			Vector3[] newVertices = (Vector3[])_origVertices.Clone();
			for (int i = 0; i < characterCount; i++)
			{
				TMP_CharacterInfo charInfo = textInfo.characterInfo[i];
				int vertexIndex = charInfo.vertexIndex;

				if (!charInfo.isVisible)
					continue;

				//wave color
				Color c = Vector4.Lerp(Vector4.one, new Vector4(1, 0, 0, 1), colorCurve.Evaluate(_prevTimer[i] / colorTime));
				c.a = 1;
				textInfo.meshInfo[0].colors32[vertexIndex + 0] = c;
				textInfo.meshInfo[0].colors32[vertexIndex + 1] = c;
				textInfo.meshInfo[0].colors32[vertexIndex + 2] = c;
				textInfo.meshInfo[0].colors32[vertexIndex + 3] = c;
				text.UpdateVertexData(TMP_VertexDataUpdateFlags.Colors32);

				//wave character
				Vector3 offset = new Vector3(0, waveCurve.Evaluate(_prevTimer[i] / waveTime), 0);

				newVertices[vertexIndex + 0] = newVertices[vertexIndex + 0] + offset;
				newVertices[vertexIndex + 1] = newVertices[vertexIndex + 1] + offset;
				newVertices[vertexIndex + 2] = newVertices[vertexIndex + 2] + offset;
				newVertices[vertexIndex + 3] = newVertices[vertexIndex + 3] + offset;

				//shake character
				Vector3 shake = new Vector3(Random.Range(-shakeAmount, shakeAmount), Random.Range(-shakeAmount, shakeAmount), 0);

				newVertices[vertexIndex + 0] = newVertices[vertexIndex + 0] + shake;
				newVertices[vertexIndex + 1] = newVertices[vertexIndex + 1] + shake;
				newVertices[vertexIndex + 2] = newVertices[vertexIndex + 2] + shake;
				newVertices[vertexIndex + 3] = newVertices[vertexIndex + 3] + shake;

				//After work
				_prevTimer[i] += Time.deltaTime;
			}

			for (int i = 0; i < textInfo.meshInfo.Length; i++)
			{
				textInfo.meshInfo[i].mesh.vertices = newVertices;
				text.UpdateGeometry(textInfo.meshInfo[i].mesh, i);
			}
			yield return new WaitForSeconds(0.03f);

			if (isOver)
				break;
		}
		for (int i = 0; i < textInfo.meshInfo.Length; i++)
		{
			textInfo.meshInfo[i].mesh.vertices = _origVertices;
			text.UpdateGeometry(textInfo.meshInfo[i].mesh, i);
		}
		for (int i = 0; i < textInfo.meshInfo[0].vertices.Length; ++i)
		{
			textInfo.meshInfo[0].colors32[i] = Color.white;
			text.UpdateVertexData(TMP_VertexDataUpdateFlags.Colors32);
		}
		isOver = false;
	}
}
