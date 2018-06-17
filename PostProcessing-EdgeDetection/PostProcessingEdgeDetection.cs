using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessingEdgeDetection : MonoBehaviour {

	public Material EdgeDetectionMaterial; 

	// Use this for initialization
	void Start () {

		Camera.main.depthTextureMode = DepthTextureMode.DepthNormals; 
		
	}
	
	// Update is called once per frame
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, EdgeDetectionMaterial); 
	}
}
