Shader "Custom/RealTP" {
	Properties {
		_UpTexture ("Up", 2D) = "white" {}
		_SideTexture("Side", 2D) = "white" {}
		_ScaleUp("Scale up", float) = 0.1
		_ScaleSide("Scale side ", float) = 0.1

		_Color("Color", Color) = (1,0,0,1)
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _UpTexture;
		sampler2D _SideTexture; 

		struct Input {
			float3 worldPos; 
			float3 worldNormal; 
		};


		half _Glossiness;
		half _Metallic;
		half _ScaleSide; 
		half _ScaleUp; 
		half4 _Color; 

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color

			half2 yUV = IN.worldPos.xz/_ScaleUp; 
			half2 xUV = IN.worldPos.yx/_ScaleSide; 
			half2 zUV = IN.worldPos.yz/_ScaleSide; 

			half3 up_color = tex2D(_UpTexture, yUV); 
			half3 side_color = tex2D(_SideTexture, xUV);
			half3 other_side_color = tex2D(_SideTexture, zUV);

			half d = dot(IN.worldNormal, float3(0,1,0)); 

			o.Albedo = saturate(up_color * d + (side_color*(1-d) + other_side_color*(1-d)))*_Color; 

			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
