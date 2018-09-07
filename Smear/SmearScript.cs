using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmearScript : MonoBehaviour {

	public Material Mat; 
	public int Refresh; 
	// Renderer rend; 

	Vector3 lastpos; 
	int counter; 
	// Use this for initialization
	void Start () {
		lastpos = transform.position; 
	}
	
	// Update is called once per frame
	void Update () {

		
		Mat.SetVector("_Position", transform.position); 
		Mat.SetVector("_PrevPosition", lastpos); 

		if(counter % Refresh == 0)
		{	
			lastpos = transform.position; 
			counter = 0; 
		}
		counter += 1; 

	}
}
