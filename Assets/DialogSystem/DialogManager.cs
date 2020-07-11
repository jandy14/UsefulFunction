using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class DialogManager : MonoBehaviour
{
	public TMP_Text dialogText;
	public Image dialogPortrait;
	public List<Dialog> dialogList;
	public TagManager tagManager;
	public TextEffectManager textEffectManager;
	public List<string> defaultEffects;


	private Vector2 portraitSize;
	private Vector2 textAreaSize;

	void Start()
    {
		textEffectManager.InitEffect();
		dialogText.ForceMeshUpdate();
		tagManager = new TagManager();
		tagManager.AddTag(textEffectManager.GetTagName());

		portraitSize = dialogPortrait.rectTransform.sizeDelta;
		textAreaSize = dialogText.rectTransform.sizeDelta;
		//for debug
		//List<string> dialog = new List<string>();
		//dialog.Add("today i'll gonna show you <bye>thiiiiiiiiis</bye>");
		//dialog.Add("it can be also <wave>waaaaaaveeed</wave>.");
		//dialog.Add("<bye>Important thing</bye> is it can be mixed <wave>in one sentance</wave>");
		//dialog.Add("<wave><bye>in one word</bye></wave>");
		//dialog.Add("you can make <grad>your own effect</grad><reveal=0.4>...</reveal><hi>WOW!!</hi>");
		//SetDialog(dialog);
		NextDialog();
	}

	public void SetDialog(List<Dialog> pDialog)
	{
		dialogList = pDialog;
	}
	public string NextDialog()
	{
		Dialog text;

		try { text = dialogList[0]; }
		catch { return null; }

		textEffectManager.ResetAllEffect();
		SetText(text.content);
		SetPortrait(text.portrait);
		dialogList.RemoveAt(0);
		return text.content;
	}
	public void SkipEffect()
	{
		textEffectManager.SkipAllEffect();
	}
	public void SetPortrait(Sprite pImage)
	{
		if(pImage != null)
		{
			dialogPortrait.rectTransform.sizeDelta = portraitSize;
			dialogText.rectTransform.sizeDelta = textAreaSize;
			dialogText.rectTransform.localPosition = new Vector3 (portraitSize.x / 2, 0, 0);
			dialogPortrait.sprite = pImage;
		}
		else
		{
			dialogPortrait.rectTransform.sizeDelta = Vector2.zero;
			dialogText.rectTransform.sizeDelta = textAreaSize + Vector2.right * portraitSize.x;
			dialogText.rectTransform.localPosition = Vector3.zero;
		}
	}
	public void SetText(string pRichText)
	{
		dialogText.text = tagManager.ExtractTag(pRichText);
		dialogText.ForceMeshUpdate();
		textEffectManager.SetTagValue(tagManager.tagInfos);
		ApplyDefaultEffect();
		tagManager.DebugTagManager();
	}
	public void EventProcessing()
	{
		if(textEffectManager.CheckAllFinished())
		{
			NextDialog();
		}
		else
		{
			SkipEffect();
		}
	}
	private void ApplyDefaultEffect()
	{
		foreach (string tag in defaultEffects)
		{
			textEffectManager.SetTagValue(tag, 0, dialogText.textInfo.characterCount);
		}
	}
	private void Update()
	{
		if(Input.GetKeyDown(KeyCode.Space))
		{
			EventProcessing();
		}
	}

}
[System.Serializable]
public class Dialog
{
	public string content;
	public Sprite portrait;
}