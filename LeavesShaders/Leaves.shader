Shader "Custom/Leaves" {
	Properties {
		_Alpha("Alpha tex", 2D) = "white" {}
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Normal("Normal map", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_NormalIntensity("Normal intensity", float) = 0.1
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent"}
		LOD 200
		Cull Off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Alpha; 
		sampler2D _Normal; 

		struct Input {
			float2 uv_MainTex;
			// floa
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _NormalIntensity; 

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed a = tex2D (_Alpha, IN.uv_MainTex);

			// discard(a-0.8);
			if(a < 0.8)
				discard;
			
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Normal =  _NormalIntensity*UnpackNormal (tex2D (_Normal, IN.uv_MainTex));
			o.Alpha = a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
