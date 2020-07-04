using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DialogManager : MonoBehaviour
{
	public TMP_Text dialogText;
	public TagManager tagManger;

    void Start()
    {
		tagManger = new TagManager();
		tagManger.AddTag("hi");
		dialogText.text = tagManger.ExtractTag(dialogText.text);
		//tagmanager 값 확인용
		//foreach(TagInfo tag in tagManger.tagInfos)
		//{
		//	Debug.Log(string.Format("{0}:{1}:{2}:{3}", tag.tagName, tag.startIndex, tag.endIndex, tag.length));
		//	foreach(KeyValuePair<string,string> v in tag.values)
		//	{
		//		Debug.Log(string.Format("{0}:{1}", v.Key,v.Value));
		//	}
		//}
		StartCoroutine(Progress());
    }

	IEnumerator Progress()
	{
		dialogText.ForceMeshUpdate();
		TMP_TextInfo textInfo = dialogText.textInfo;
		int totalVisibleCharacters = textInfo.characterCount;
		Debug.Log(dialogText.text);
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
