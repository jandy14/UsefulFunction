using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Text.RegularExpressions;
using System;

public class TagManager
{
	public List<string> tags;
	public List<TagInfo> tagInfos;

	private List<TagInfo> unfinishedTagInfo;

	public TagManager()
	{
		tags = new List<string>();
		tagInfos = new List<TagInfo>();
		unfinishedTagInfo = new List<TagInfo>();
	}

	public void AddTag(string pTag)
	{
		if(!tags.Contains(pTag))
			tags.Add(pTag);
	}
	public void AddTag(List<string> pTagList)
	{
		foreach(string tag in pTagList)
		{
			AddTag(tag);
		}
	}
	public void RemoveTag(string pTag)
	{
		if (tags.Contains(pTag))
			tags.Remove(pTag);
	}
	public string ExtractTag(string pText)
	{
		Init();
		int index = 0;
		int pivot = 0;
		Regex regex = new Regex("<[^<>]*>");

		while (true)
		{
			Match m = regex.Match(pText.Substring(index+pivot));

			if (m.Success)
			{
				index += m.Index;
				string tagName = GetTagName(m.Value);
				
				if (tags.Contains(tagName))
				{
					ParseTag(m.Value, index);
					pText = pText.Remove(index+pivot, m.Length);
				}
				else
					pivot += m.Length;
				//Debug.Log(string.Format("{0}:{1}:{2}", m.Index, m.Value, m.Length));
			}
			else
			{
				index += pText.Substring(index + pivot).Length;
				//닫히지 않은 태그 처리
				CloseAll(index);
				break;
			}
		}
		return pText;
	}

	private void Init()
	{
		tagInfos.Clear();
		unfinishedTagInfo.Clear();
	}
	private string GetTagName(string pTag)
	{
		foreach (string s in pTag.Split(new char[] { '<', '/', '>', ' ' }))
		{
			if (s != "")
			{
				return s;
			}
		}
		return "";
	}
	private void ParseTag(string pTag, int pStartIndex)
	{
		string[] values = pTag.Split(new char[] { '<', '/', '>', ' ' });
		TagInfo tagInfo = new TagInfo();
		Dictionary<string, string> tagValues = new Dictionary<string, string>();

		//닫는 태그라면
		if(pTag[1] == '/')
		{
			CloseTag(GetTagName(pTag), pStartIndex);
			return;
		}

		//아니라면 unfinishedTagInfo 에 값넣기
		bool isValue = false;
		foreach(string v in values)
		{
			if (v == "")
				continue;
			if(!isValue)
			{
				tagInfo.tagName = v;
				isValue = true;
			}
			else
			{
				string[] tagValue = v.Split('=');
				tagValues.Add(tagValue[0], tagValue[1]);
			}
		}
		tagInfo.startIndex = pStartIndex;
		tagInfo.values = tagValues;

		unfinishedTagInfo.Add(tagInfo);
	}
	private void CloseTag(string pTagName, int pLastIndex)
	{
		for(int i = unfinishedTagInfo.Count - 1; i >= 0; --i)
		{
			if(unfinishedTagInfo[i].tagName == pTagName)
			{
				unfinishedTagInfo[i].endIndex = pLastIndex;
				tagInfos.Add(unfinishedTagInfo[i]);
				unfinishedTagInfo.RemoveAt(i);
				break;
			}
		}
	}
	private void CloseAll(int pLastIndex)
	{
		//unfinishedTagInfo에 있는거 다 정리하기
		for (int i = unfinishedTagInfo.Count - 1; i >= 0; --i)
		{
			unfinishedTagInfo[i].endIndex = pLastIndex;
			tagInfos.Add(unfinishedTagInfo[i]);
			unfinishedTagInfo.RemoveAt(i);
		}
	}
}

public class TagInfo
{
	public string tagName = "";
	public Dictionary<string, string> values;
	public int startIndex = 0;
	public int endIndex = 0;
	public int length { get { return endIndex - startIndex; } }

	public TagInfo() { }
	public TagInfo(string pName, int pStart, int pEnd)
	{
		tagName = pName;
		startIndex = pStart;
		endIndex = pEnd;
	}
}