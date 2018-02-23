Shader "Unlit/Matcap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 worldNormal : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;


			// I was using UnityObjectToClipPos to transform the vertex normal.
			// There are two problems with that. First is clip space is not view space. 
			//Clip space is a step after view space and before screen space that's used for rasterization (how all modern GPUs calculate what pixels to render). 
			//The second is that that function is for transforming a position, and a normal is a direction.
			//Using UnityObjectToWorldNormal will get the vertex normal into world space, and is the correct first step, 
			//but still need to transform the world normal into view space. 
			//There's no handy included function for that, but it's simple enough to add
 	

			// Solution: mul((float3x3)UNITY_MATRIX_V, UnityObjectToWorldNormal(v.normal))
			

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul((float3x3)UNITY_MATRIX_V, UnityObjectToWorldNormal(v.normal)).xy*0.3 + 0.5;  //UnityObjectToClipPos(v.normal)*0.5 + 0.5; 
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.worldNormal);
				// apply fog
				return col;
			}
			ENDCG
		}
	}
}
