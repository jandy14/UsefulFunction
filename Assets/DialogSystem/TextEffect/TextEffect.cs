using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public abstract class TextEffect : MonoBehaviour
{
	public TMP_Text text;
	public List<TagInfo> tagInfos;
	public bool isFinished { get; protected set; }
	public bool isWorking { get; protected set; }

	protected void Awake()
	{
		tagInfos = new List<TagInfo>();
		isFinished = true;
		isWorking = true;
	}

	public virtual void AddInfo(TagInfo pTagInfo)
	{
		tagInfos.Add(pTagInfo);
	}
	public virtual void SetText(TMP_Text pText)
	{
		text = pText;
	}
	public virtual void ResetInfo()
	{
		tagInfos.Clear();
	}
	public virtual void StartEffect() => isWorking = true;
	public virtual void StopEffect() => isWorking = false;
	public virtual void SkipToTheEnd() { isFinished = true; }
	public virtual void ResetEffect() { ResetInfo(); isFinished = true; isWorking = true; }
	public abstract void OneFrameWork();
}
