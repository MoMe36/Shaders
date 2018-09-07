using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmearDemo : MonoBehaviour {

	public Vector3 [] position; 
	public float Speed; 
	public float PauseFor; 

	public bool ShowGizmos; 
	float timer; 
	bool in_pause; 
	int current; 
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	

		if(!in_pause)
		{
			transform.position = Vector3.MoveTowards(transform.position, position[(current+1)%position.Length], Speed*Time.deltaTime); 
		}
		else
		{
			timer -= Time.deltaTime; 
			if(timer <= 0f)
			{
				in_pause = false; 
			}
		}
		
		float distance = (transform.position - position[(current+1)%position.Length]).magnitude; 

		if(distance < 0.3f && !in_pause)
		{
			in_pause = true; 
			current = (distance < 0.3f) ? (current+1)%position.Length : current; 
			timer = PauseFor; 
		}

	}

	void OnDrawGizmos()
	{
		if(ShowGizmos)
		{
			foreach(Vector3 v in position)
			{
				Gizmos.DrawSphere(v, 1f); 
			}
		}
	}
}
