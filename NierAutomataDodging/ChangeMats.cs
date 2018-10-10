using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMats : MonoBehaviour {

	public Material Basic; 
	public Material DodgeMat; 
	public float SpeedDistance = 1f; 
	public float SpeedAngle =1f; 

	MeshRenderer renderer; 


	public enum MatStates {normal, dodge};
	public MatStates current_state = MatStates.normal;  
	public bool Change; 

	bool add_distance = false; 
	float distance_value = 0f; 
	float angle_value = 0f; 

	// Use this for initialization
	void Start () {


		renderer = GetComponent<MeshRenderer>(); 
		
	}
	
	// Update is called once per frame
	void Update () {


		if(Change)
		{
			Change = false; 
			if(current_state == MatStates.normal)
			{
				current_state = MatStates.dodge; 
				renderer.material= DodgeMat; 
				add_distance = true; 
			}
			else
			{
				current_state = MatStates.normal; 
				renderer.material= Basic; 
				add_distance = false; 
				DodgeMat.SetFloat("_Distance", 0f); 
				distance_value = 0f; 
				angle_value = 0f; 
			}	
		}

		if(add_distance)
		{
			distance_value = Mathf.Lerp(distance_value, 1f, Time.deltaTime*SpeedDistance); 
			angle_value += Time.deltaTime*SpeedAngle; 
			DodgeMat.SetFloat("_Distance", distance_value); 
			DodgeMat.SetFloat("_Angle", angle_value); 
		}

		
	}
}
