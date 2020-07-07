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
		dialog.Add("aaaaaaa<hi>aaaaaa</hi>aaaaaaaaaaaaaaaa");
		dialog.Add("bbbbbbbbbbbb<wave>bbbbbbbbb</wave>bbbbbbbb");
		dialog.Add("ccccc<bye>ccccccccccccccc</bye>ccccccccc");
		SetDialog(dialog);
		NextDialog();
	}

	public void SetDialog(List<string> pDialog)
	{
		dialogList = pDialog;
	}
	public void NextDialog()
	{
		string text = "";
		try
		{
			text = dialogList[0];
		}
		catch
		{
			return;
		}
		textEffectManager.ResetAllEffect();
		SetText(text);
		dialogList.RemoveAt(0);
	}
	public void SkipEffect()
	{
		textEffectManager.SkipAllEffect();
	}
	public void SetText(string pRichText)
	{
		dialogText.text = tagManager.ExtractTag(pRichText);
		textEffectManager.SetTagValue(tagManager.tagInfos);
		ApplyDefaultEffect();
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
