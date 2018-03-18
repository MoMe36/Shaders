Shader "Custom/TerrainHeightPlusMask" {
	Properties {
		_Limits("Limites", Vector) = (0,0,0)
		_Height("Min height", float) = 0.1
		_ScaleUp("Scale up", float) = 0.1 
		_ScaleMask("Scale mask", float) = 0.1 
		_Scale("Scale", float) = 0.1 
		_Mask ("Mask", 2D) = "white" {}
		_UpTex("Up texture", 2D) = "white" {}
		_LowTex1("Low texture 1", 2D) = "white" {}
		_LowTex2("Low texture 2", 2D) = "white" {}
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _Mask;
		sampler2D _UpTex; 
		sampler2D _LowTex2; 
		sampler2D _LowTex1;
		half _Height; 
		half _Scale; 
		half _ScaleUp; 
		half _ScaleMask; 
		half4 _Limits; 
		struct Input{
			float3 worldPos; 
		};

		half rand(half2 co)
		{
    		return frac(sin(dot(co.xy ,half2(12.9898,78.233))) * 43758.5453);
		}

		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input v, inout SurfaceOutputStandard o) {
			
			half d = -(v.worldPos.y - _Height); 
			half m = step(d,_Limits.x); 
			half l = m*lerp(1.,_Limits.y, step(0,d));

			// other color 
			fixed4 c1 = tex2D(_LowTex1,v.worldPos.xz/_Scale); 
			fixed4 c2 = tex2D(_LowTex2,v.worldPos.xz/_Scale); 

			half d2 = tex2D(_Mask, v.worldPos.xz/_ScaleMask); 

			o.Albedo = l*tex2D(_UpTex, v.worldPos.xz/_ScaleUp) + (1-l)*(d2*c1 + (1-d2)*c2); 
		}
		ENDCG
	}
	FallBack "Diffuse"
}
