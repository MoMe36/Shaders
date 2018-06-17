using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PostProcessDepthGrayscale : MonoBehaviour {

	public Material mat;
	// Use this for initialization
	void Start () {
		Camera.main.depthTextureMode = DepthTextureMode.Depth; 
	}
	
	// Update is called once per frame
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, mat);
	}

}
