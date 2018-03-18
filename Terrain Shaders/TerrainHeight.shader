Shader "Custom/TerrainHeight" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_TexOne("Tex", 2D) = "white" {}
		_TexTwo("Tex", 2D) = "white" {}

		_ScaleOne("Scale one", float) = 1
		_ScaleTwo("Scale two", float) = 1


		_Limit("Limit", float) = 0.
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float3 worldPos; 
		};

		// This shader applies color based on world position height. 

		fixed4 _Color;

		sampler2D _TexTwo; 
		sampler2D _TexOne; 

		half _Limit; 
		half _ScaleTwo; 
		half _ScaleOne; 

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		half rand(half2 co){
    		return frac(sin(dot(co.xy ,half2(12.9898,78.233))) * 43758.5453);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {

			half d = step(_Limit, IN.worldPos.y);

			half l = abs(_Limit-IN.worldPos.y); 
			l = step(0.3*rand(IN.worldPos.xx),l);


			half2 coord1 = IN.worldPos.xz/_ScaleOne; 
			half2 coord2 = IN.worldPos.xz/_ScaleTwo;


			fixed4 c1 = tex2D (_TexOne, coord1);
			fixed4 c2 = tex2D (_TexTwo, coord2); 

			// fixed4 c = d*c1 + (1-d)*c2;
			fixed4 c = l*(d*c1 + (1-d)*c2) + (1-l)*(0.5*c1 + 0.5*c2); // - 0.1*sin(IN.worldPos.y)*l; 
			o.Albedo = c.rgb*_Color; 
			o.Alpha = c.a; 
		}
		ENDCG
	}
	FallBack "Diffuse"
}
