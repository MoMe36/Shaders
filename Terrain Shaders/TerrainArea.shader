Shader "Custom/TerrainArea" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Color2 ("Color", Color) = (1,1,1,1)
		_Scale("Scale", float) = 0.1 
		_Area("Map", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _Area;

		// void vert(inout appdata_full v, out Input o)
		// {	
		// 	UNITY_INITIALIZE_OUTPUT(Input o); 
		// 	o.localPos = v.vertex.xyz; 
		// }

		// This shader apply a color based on local pos and a mask texture
		struct Input {
			float3 worldPos; 
			
		};

		fixed4 _Color;
		fixed4 _Color2; 
		half _Scale;


		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {

			float3 local = IN.worldPos -  mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz; 
			half2 d = local.xz/_Scale; 
			// Albedo comes from a texture tinted by color
			// half2 d = IN.worldPos.xx/_Scale; 
			half color = tex2D(_Area,d); 
			fixed4 c = color*_Color2 + (1-color)*_Color; 
			o.Albedo = c; 
			o.Alpha = 1; 
		}
		ENDCG
	}
	FallBack "Diffuse"
}
