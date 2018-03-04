Shader "Unlit/NewGrassShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Size("Size", float) = 0.1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL; 
				float2 uv : TEXCOORD0;
			};

			struct v2g
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL; 
			};

			struct g2f
			{
				float4 pos : SV_POSITION; 
				float3 normal : NORMAL; 
			}; 

			fixed4 _Color; 
			fixed _Size; 

			v2g vert (appdata v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.normal = v.normal; //UnityObjectToWorldNormal(v.normal); 
				o.uv = v.uv; 
				return o;
			}

			[maxvertexcount(4)]
			void geom(line v2g l[2], inout TriangleStream<g2f> ts)
			{
				float3 normal = normalize(l[0].normal + l[1].normal); 

				float4 v0 = l[0].vertex + (normal,0.); 
				float4 v1 = l[1].vertex + (normal,0.); 

				float3 n_quad = UnityObjectToWorldNormal(cross(normal, (v0.xyz-v1.xyz))); 
				// float3 n_quad = cross(normal, (v0.xyz-v1.xyz)); 

				g2f o; 
				o.pos = UnityObjectToClipPos(l[0].vertex); 
				o.normal = n_quad; 
				ts.Append(o); 

				o.pos = UnityObjectToClipPos(l[1].vertex); 
				o.normal = n_quad; 
				ts.Append(o); 

				o.pos = UnityObjectToClipPos(v0); 
				o.normal = n_quad; 
				ts.Append(o); 

				o.pos = UnityObjectToClipPos(v1); 
				o.normal = n_quad; 
				ts.Append(o); 


			}
			[maxvertexcount(4)]
			// void geom(point v2g IN[1], inout TriangleStream<g2f> ts)
			// {

			// 	float3 direction = (1.,0.,0.); 
			// 	float3 center = IN[0].vertex.xyz; 
			// 	float3 up = center + IN[0].normal; 

			// 	float3 normal = normalize(cross(up-center, direction));
			// 	float4 v0 = IN[0].vertex;

			// 	g2f o; 

			// 	o.pos = UnityObjectToClipPos(v0); 
			// 	o.normal = normal;
			// 	ts.Append(o); 

			// 	o.pos = UnityObjectToClipPos(v0 + _Size*((direction),1.) ); 
			// 	o.normal = normal; 
			// 	ts.Append(o); 

			// 	o.pos = UnityObjectToClipPos(v0 + _Size*((direction + up),1.) );  
			// 	o.normal = normal; 
			// 	ts.Append(o); 

			// 	o.pos = UnityObjectToClipPos(v0 + _Size*((up),1.));  
			// 	o.normal = normal; 
			// 	ts.Append(o); 

			// }
			
			fixed4 frag (g2f i) : SV_Target
			{
				float d = dot(i.normal, _WorldSpaceLightPos0.xyz); 
				fixed4 col = _Color; 
				//col.rgb *= d; 
				return col;
			}
			ENDCG
		}
	}
}
