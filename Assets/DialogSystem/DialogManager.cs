using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DialogManager : MonoBehaviour
{
	public TMP_Text dialogText;

    void Start()
    {
		StartCoroutine(Progress());
    }


	IEnumerator Progress()
	{
		dialogText.ForceMeshUpdate();
		TMP_TextInfo textInfo = dialogText.textInfo;
		int totalVisibleCharacters = textInfo.characterCount;
		Debug.Log(textInfo.lineCount);
		Debug.Log(textInfo.lineInfo[0].characterCount);
		Debug.Log(textInfo.lineInfo[1].characterCount);
		Debug.Log(textInfo.lineInfo[2].characterCount);
		Debug.Log(totalVisibleCharacters);
		int visibleCount = 0;

		while(true)
		{
			dialogText.maxVisibleCharacters = visibleCount;
			visibleCount += 1;

			if (visibleCount > totalVisibleCharacters)
				break;
			yield return null;

		}
		yield return null;
	}

}
