using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderControl : MonoBehaviour {

	public Material material; 
	public float Trigger = 0.5f; 
	public GameObject Position; 

	public bool Fire = true; 

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		if (Fire)
		{
			Trigger = 0.5f; 
			Fire = false; 
		}
		if(Trigger>0f)
			Trigger -= Time.deltaTime; 

		Trigger = (Trigger<0) ? 0f : Trigger;
		material.SetFloat("_Trigger", Trigger);
		Vector4 pos = new Vector4(Position.transform.position.x,Position.transform.position.y,Position.transform.position.z,1f);
		material.SetVector("_Center", pos);
	}
}
