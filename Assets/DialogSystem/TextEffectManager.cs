using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using TMPro;

public class TextEffectManager : MonoBehaviour
{
	public TMP_Text dialogText;
	public List<TextEffectSet> textEffectSets;

	private bool isWorking = false;

	public List<string> GetTagName()
	{
		List<string> names = new List<string>();
		foreach(TextEffectSet set in textEffectSets)
		{
			names.Add(set.name);
		}
		return names;
	}
	public void StartAllEffect()
	{
		isWorking = true;
		foreach (TextEffectSet t in textEffectSets)
		{
			t.textEffect.StartEffect();
		}
	}
	public void StopAllEffect()
	{
		isWorking = false;
		foreach (TextEffectSet t in textEffectSets)
		{
			t.textEffect.StopEffect();
		}
	}
	public void ResetAllEffect()
	{
		foreach (TextEffectSet t in textEffectSets)
		{
			t.textEffect.ResetEffect();
		}
	}
	public void SkipAllEffect()
	{
		foreach (TextEffectSet t in textEffectSets)
		{
			t.textEffect.SkipToTheEnd();
		}
	}
	public void SetTagValue(List<TagInfo> pTagInfos)
	{
		foreach(TagInfo info in pTagInfos)
		{
			foreach(TextEffectSet effect in textEffectSets)
			{
				if(effect.name == info.tagName)
				{
					effect.textEffect.AddIndex(info.startIndex, info.endIndex);
					break;
				}
			}
		}
	}

	private void InitEffect()
	{
		foreach (TextEffectSet t in textEffectSets)
		{
			t.textEffect.ResetEffect();
		}
	}
	private void WorkEffect()
	{
		foreach(TextEffectSet t in textEffectSets)
		{
			t.textEffect.OneFrameWork();
		}
	}
	private void WorkInFrame()
	{
		dialogText.ForceMeshUpdate();
		WorkEffect();
		dialogText.UpdateVertexData();
	}
	private void Awake()
	{
		InitEffect();
	}
	private void Update()
	{
		if (isWorking)
		{
			WorkInFrame();
		}
	}
}

[Serializable]
public class TextEffectSet
{
	public string name;
	public TextEffect textEffect;
}
