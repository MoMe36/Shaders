Shader "Custom/GrassGeometry" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_GrassHeight("Grass height",Float) = 1.0
		_GrassWidth("Grass width",Float) = 1.0
	}
	SubShader {
	Pass {


		Tags { "RenderType"="Opaque" }
		LOD 200
		CULL OFF 
		CGPROGRAM

		#include "UnityLightingCommon.cginc"
		#include "UnityCG.cginc"
		#pragma vertex vert 
		#pragma fragment frag
		#pragma geometry geom 

		#pragma target 4.0

		half _GrassHeight; 
		half _GrassWidth; 
		fixed4 _Color;

		struct v2g 
		{
			float4 pos: SV_POSITION; 
			float3 norm : NORMAL; 
		};

		struct g2f
		{
			float4 pos : POSITION; 
			float3 norm : NORMAL ; 
		}; 


		v2g vert(appdata_full v)
		{
			float3 v0 = v.vertex.xyz; 
			v2g OUT; 

			OUT.pos = v.vertex; 
			OUT.norm = UnityObjectToWorldNormal(v.normal); 

			return OUT;
		}

		[maxvertexcount(4)]
		void geom(triangle v2g IN[3], inout TriangleStream <g2f> triStream)
		{
			float3 perpAngle = float3(1,0,0); 
			float3 faceNormal = cross(perpAngle, IN[0].norm); 
			float3 v0 = IN[0].pos.xyz;
			float3 v1 = IN[0].pos.xyz + IN[0].norm*_GrassHeight; 

			g2f OUT ;
			OUT.pos = UnityObjectToClipPos(v0 + perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			triStream.Append(OUT); 

			OUT.pos = UnityObjectToClipPos(v0 - perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(v1 + perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(v1 - perpAngle*0.5*_GrassHeight); 
			OUT.norm = faceNormal; 
			triStream.Append(OUT);

		}

		half4 frag(g2f IN) : COLOR
		{
			float n = dot(IN.norm, normalize(_WorldSpaceLightPos0 - IN.pos));
			return _Color*n; 
		}
		ENDCG
	}
	}
}
