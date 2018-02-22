Shader "Custom/ToonOutlineNOrmal" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_OutlineColor("Color", Color) = (1,1,1,1)
		_OutlineRange("Range outline", Range (-1.,1.)) = 0.
		_Limits("Limites", Vector) = (0.,0.5,0.7,1.)
		_Bump("Normal map", 2D) = "white" {}
		_NormalIntensity("Normal intensity", Range(0.0,3.0)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _Bump;
		sampler2D _MainTex;
		float3 _Limits; 
		half _NormalIntensity; 

		struct Input {
			float2 uv_MainTex;
			float3 WorldNormalVector; 
			float3 viewDir; 
			float2 uv_Bump;
		};

		half4 LightingToon(SurfaceOutput s, half3 lightDir, float3 worldNormal)
		{
			float d = dot(s.Normal, lightDir); 
			float n = step(_Limits.x, d)*step(d,_Limits.y); 
			float n1 = step(_Limits.y, d)*step(d,_Limits.z); 
			float n2 = step(_Limits.z,d); 

			n = 0.3*n + n1*0.7 + n2; 

			half4 c; 
			c.rgb = s.Albedo*n; 
			return c; 
		}

		fixed4 _OutlineColor;
		fixed _OutlineRange; 
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			float d = dot(o.Normal, IN.viewDir); 
			d = 1-step(d,_OutlineRange); 

			fixed4 c = d*tex2D (_MainTex, IN.uv_MainTex) * _Color + (1-d)*_OutlineColor;
			o.Albedo = c.rgb;
			//o.Normal = UnpackNormal (tex2D (_Bump, IN.uv_Bump))*_NormalIntensity;
			o.Normal = UnpackScaleNormal(tex2D(_Bump, IN.uv_Bump),_NormalIntensity);
			//o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
			// Metallic and smoothness come from slider variables
			o.Alpha = c.a;

			// float3 worldNormal; INTERNAL_DATA - contains world normal vector if surface shader writes to o.Normal. 
			//To get the normal vector based on per-pixel normal map, use WorldNormalVector (IN, o.Normal).
		}
		ENDCG

	}
	FallBack "Diffuse"
}