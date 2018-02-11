Shader "Custom/MehdToonOutline" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_OutlineColor("Color outline", Color) = (0,0,0,1)
		_OutlineWidth("Outline width", Range(0.,1.)) = 0.1
		_Tresholds("Ranges", Vector) = (0.4,0.7,0.4,0.7)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Tresholds; 

		half4 LightingToon (SurfaceOutput s, float3 lightDir, float3 worldNormal)
		{
			float n = dot(lightDir, worldNormal); 
			float n1 = step(n,_Tresholds.r); 
			float n2 = step(_Tresholds.r,n)*step(n,_Tresholds.g); 
			float n3 = step(_Tresholds.g,n); 

			float result = _Tresholds.b*n1 + _Tresholds.a*n2 + 1.*n3; 
			half4 c; 
			c.rgb = result*s.Albedo; 
			c.a = s.Alpha; 
			return c; 
		}

		

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal; 
			float3 viewPos; 
		};

		fixed4 _Color;
		fixed4 _OutlineColor; 
		sampler2D _MainTex;
		fixed _OutlineWidth;
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {

			float d = dot(IN.viewPos, IN.worldNormal); 
			float dN = 1-step(d, _OutlineWidth);
			o.Albedo = dN*_OutlineColor + (1-dN)*tex2D(_MainTex, IN.uv_MainTex)*_Color.rgb; 

		}
		ENDCG
	}
	FallBack "Diffuse"
}
