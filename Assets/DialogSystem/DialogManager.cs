using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DialogManager : MonoBehaviour
{
	public TMP_Text dialogText;
	public TagManager tagManger;
	public TextEffect shake;
	public TextEffect shake2;

	void Start()
    {
		tagManger = new TagManager();
		tagManger.AddTag("hi");
		dialogText.text = tagManger.ExtractTag(dialogText.text);
		
		StartCoroutine(Progress());
		shake2.AddIndex(1, 2);
		shake.AddIndex(0, 1);
	}
	public void SetText(string pRichText)
	{
		dialogText.text = tagManger.ExtractTag(pRichText);
	}
	private void Update()
	{
		dialogText.ForceMeshUpdate();
		shake2.Work();
		shake.Work();

		//dialogText.UpdateVertexData();
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

	//tagmanager 값 확인용
	private void DebugTagManager()
	{
		foreach (TagInfo tag in tagManger.tagInfos)
		{
			Debug.Log(string.Format("{0}:{1}:{2}:{3}", tag.tagName, tag.startIndex, tag.endIndex, tag.length));
			foreach (KeyValuePair<string, string> v in tag.values)
			{
				Debug.Log(string.Format("{0}:{1}", v.Key, v.Value));
			}
		}
	}
}
