Shader "Custom/Holographic" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_DotProd("Rim Effet", Range(-1,1)) =  0.1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert alpha:fade nolighting

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float3 worldNormal; 
			float3 viewDir; 
		};

		fixed4 _Color;
		float _DotProd; 

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal))); 
			float alpha = border*(1- _DotProd) + _DotProd;
			o.Alpha = c.a*alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
