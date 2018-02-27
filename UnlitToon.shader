Shader "Unlit/UnlitToon"
{
	Properties
	{
		_Color ("Color", Color) = (1,0,0,1)
	}
	SubShader
	{
		Tags {"LightMode" = "ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL; 
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD1; 
				fixed4 diff : COLOR0; 
			};

			fixed4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o; 
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv; 
				o.normal = UnityObjectToWorldNormal(v.normal); 

				half nl = dot(v.normal, _WorldSpaceLightPos0.xyz);
				half d = step(0,nl)*step(nl,0.3); 
				half d1 = step(0.3,nl)*step(nl,0.5); 
				half d2 = step(0.5,nl); 

				nl = 0.1 + 0.3*d + 0.5*d1 + 0.8*d2; 
				o.diff = nl;
				return o; 
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = i.diff*_Color; 
				// apply fog
				return col;
			}
			ENDCG
		}
	}
}
