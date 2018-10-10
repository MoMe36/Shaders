Shader "Custom/MultiPassTest" {
	Properties {

		_Angle("Angle", float) = 0
		_Distance("Distance", Range(0,1)) = 0.5
		_DistanceMax("MaxDistance", float) = 2
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		half _Distance; 
		half _Angle; 
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _DistanceMax; 

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			half decal = fmod(_Angle, 6.28); 
			v.vertex.x += cos(decal)*_Distance*_DistanceMax;
			v.vertex.z += sin(decal)*_Distance*_DistanceMax; 
		}

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		half _Distance; 
		half _Angle; 
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _DistanceMax; 


		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			half decal = fmod(_Angle + 6.28/3., 6.28) ; 
			v.vertex.x += cos(decal)*_Distance*_DistanceMax;
			v.vertex.z += sin(decal)*_Distance*_DistanceMax; 
		}

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		half _Distance; 
		half _Angle; 
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _DistanceMax; 

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			half decal = fmod(_Angle + 2*6.28/3., 6.28) ;
			v.vertex.x += cos(decal)*_Distance*_DistanceMax;
			v.vertex.z += sin(decal)*_Distance*_DistanceMax; 
		}

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG

		// Pass{

		// 	Lighting On
		// }
	}
	FallBack "Diffuse"
}
