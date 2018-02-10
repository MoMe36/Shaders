Shader "Custom/GrassGeo" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_GrassHeight("Grass height",Float) = 1.0
		_GrassWidth("Grass width",Float) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		CULL OFF 
		CGPROGRAM


		#include "UnityCG.cginc"
		#pragma vertex vert 
		#pragma fragment frag
		#pragma geometry geom 

		#pragma target 4.0

		sampler2D _MainTex;
		half _GrassHeight; 
		half _GrassWidth; 
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		struct v2g 
		{
			float4 pos: SV_POSITION; 
			float3 norm : NORMAL; 
			// float2 uv : TEXCOORD0; 
			float3 color : TEXCOORD01; 

		};

		struct g2f
		{
			float4 pos : SV_POSITION; 
			float3 norm : NORMAL ; 
			float3 diffuseColor: TEXCOORD01; 
		}; 


		v2g vert(appdata_full v)
		{
			float3 v0 = v.vertex.xyz; 
			v2g OUT; 

			OUT.pos = v.vertex; 
			OUT.norm = v.normal; 

			return OUT;
		}

		[maxvertexcount(4)]
		void geom(triangle v2g IN[1], inout TriangleStream <g2f> triStream)
		{
			float3 lightPosition = _WorldSpaceLightPos0; 
			float3 perpAngle = float3(1,0,0); 
			float3 faceNormal = cross(perpAngle, IN[0].norm); 
			float3 v0 = IN[0].pos.xyz;
			float3 v1 = IN[0].pos.xyz + IN[0].norm*_GrassHeight; 

			float3 color = IN[0].color; 

			g2f OUT ;
			OUT.pos = UnityObjectToClipPos(v0 + perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			OUT.diffuseColor = color; 
			triStream.Append(OUT); 

			OUT.pos = UnityObjectToClipPos(v0 - perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			OUT.diffuseColor = color; 
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(v1 + perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			OUT.diffuseColor = color; 
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(v1 - perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			OUT.diffuseColor = color; 
			triStream.Append(OUT);

		}

		half4 frag(g2f IN) : COLOR
		{
			return float4(IN.diffuseColor.rgb,1.0);
		}
		ENDCG
	}
}
