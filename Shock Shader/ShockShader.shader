Shader "Custom/ShockShader" {
	Properties {
		_DistanceFactor("Distance influence",Range(0.,100.)) = 50.
		_Center("Center", Vector) = (0.,0.,0.,1.)
		_Trigger("Time", Float) = 0.5
		_MaxTrigger("Max shock time", Float) = 0.5
		_Color ("Color", Color) = (1,1,1,1)
		_ShockColor("Shock Color", Color) = (0,0,0,1)
		_Freq("Frequency", Range(0.05,100)) = 0.1
		_Amplitude("Amplitude", Float) = 0.1
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
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		half _Freq; 
		half _Amplitude; 
		half _Trigger; 
		half4 _Center; 
		half _DistanceFactor; 
		fixed4 _ShockColor; 
		half _MaxTrigger; 

		struct Input {
			half time_ratio; 
			half distance_influence; 
		};

		void vert(inout appdata_full v, out Input o)
		{
			half3 worldposition = mul(unity_ObjectToWorld, v.vertex.xyz); // Distance from vertex to perturbation 
			half factor = exp(-_DistanceFactor*distance(_Center.xyz, worldposition)*0.01); // Exponentially decreasing influence

			half time_factor = (_Trigger/_MaxTrigger)*step(0.05, _Trigger); // use time factor 
			half final_factor = factor*time_factor; // group all 

			v.vertex.z += 0.01*_Amplitude*sin(_Time.y*_Freq)*final_factor; //apply 
			v.vertex.xy += 0.005*_Amplitude*sin(_Time.z*_Freq)*final_factor;

	        UNITY_INITIALIZE_OUTPUT(Input,o);
    	    o.time_ratio = time_factor;
    	    o.distance_influence = factor;
		}

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			half t = pow(IN.time_ratio,2); 
			half influence = t*IN.distance_influence;

			fixed4 c =influence*(_ShockColor) + (1-influence)*_Color; 
			// fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
