using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DialogManager : MonoBehaviour
{
	public TMP_Text dialogText;
	public TagManager tagManager;
	public TextEffectManager textEffectManager;
	public List<string> defaultEffects;

	void Start()
    {
		textEffectManager.InitEffect();
		dialogText.ForceMeshUpdate();
		tagManager = new TagManager();
		tagManager.AddTag(textEffectManager.GetTagName());

		SetText(dialogText.text);
		textEffectManager.StartAllEffect();
	}


	public void SetText(string pRichText)
	{
		dialogText.text = tagManager.ExtractTag(pRichText);
		textEffectManager.SetTagValue(tagManager.tagInfos);
		foreach(string tag in defaultEffects)
		{
			textEffectManager.SetTagValue(tag, 0, dialogText.textInfo.characterCount);
		}
	}
	private float timer = 0;
	private void Update()
	{
		timer += Time.deltaTime;
		if(timer > 4f)
		{
			//textEffectManager.StopAllEffect();
			//textEffectManager.ResetAllEffect();
		}
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
			//yield return new WaitForSeconds(0.1f);
		}
		yield return null;
	}

	//tagmanager 값 확인용
	private void DebugTagManager()
	{
		foreach (TagInfo tag in tagManager.tagInfos)
		{
			Debug.Log(string.Format("{0}:{1}:{2}:{3}", tag.tagName, tag.startIndex, tag.endIndex, tag.length));
			foreach (KeyValuePair<string, string> v in tag.values)
			{
				Debug.Log(string.Format("{0}:{1}", v.Key, v.Value));
			}
		}
	}
}
