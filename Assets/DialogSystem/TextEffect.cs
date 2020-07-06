using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public abstract class TextEffect : MonoBehaviour
{
	public TMP_Text text;
	public List<TagInfo> tagInfos;
	public bool isWorking { get; protected set; }

	protected void Awake()
	{
		tagInfos = new List<TagInfo>();
	}

	public void AddInfo(TagInfo pTagInfo)
	{
		tagInfos.Add(pTagInfo);
	}
	public void SetText(TMP_Text pText)
	{
		text = pText;
	}
	public void ResetInfo()
	{
		tagInfos.Clear();
	}
	public virtual void StartEffect() => isWorking = true;
	public virtual void StopEffect() => isWorking = false;
	public virtual void SkipToTheEnd() { }
	public virtual void ResetEffect() => ResetInfo();
	public abstract void OneFrameWork();
}
