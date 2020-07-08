using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DialogManager : MonoBehaviour
{
	public TMP_Text dialogText;
	public List<string> dialogList;
	public TagManager tagManager;
	public TextEffectManager textEffectManager;
	public List<string> defaultEffects;

	void Start()
    {
		textEffectManager.InitEffect();
		dialogText.ForceMeshUpdate();
		tagManager = new TagManager();
		tagManager.AddTag(textEffectManager.GetTagName());

		//for debug
		List<string> dialog = new List<string>();
		dialog.Add("today i'll gonna show you <bye>thiiiiiiiiis</bye>");
		dialog.Add("it can be also <wave>waaaaaaveeed</wave>.");
		dialog.Add("<bye>Important thing</bye> is it can be mixed <wave>in one sentance</wave>");
		dialog.Add("<wave><bye>in one word</bye></wave>");
		dialog.Add("you can make <grad>your own effect</grad><reveal=0.4>...</reveal><hi>WOW!!</hi>");
		SetDialog(dialog);
		NextDialog();
	}

	public void SetDialog(List<string> pDialog)
	{
		dialogList = pDialog;
	}
	public string NextDialog()
	{
		string text = "";

		try { text = dialogList[0]; }
		catch { return null; }

		textEffectManager.ResetAllEffect();
		SetText(text);
		dialogList.RemoveAt(0);
		return text;
	}
	public void SkipEffect()
	{
		textEffectManager.SkipAllEffect();
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
