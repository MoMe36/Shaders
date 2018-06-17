Shader "CustomPP/DepthGS"
{
	SubShader
	{
		Tags{ "RenderType"="Opaque" }
		// No culling or depth
		// Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _CameraDepthTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 scr_pos : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.scr_pos = ComputeScreenPos(o.vertex);
				// o.scr_pos.y = 1-o.scr_pos.y; 
				return o;
			}
			

			fixed4 frag (v2f i) : COLOR
			{
				float depthvalue = 1.- Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scr_pos)).r);
				
				half4 depth; 
				depth.rgb = depthvalue; 
				depth.a = 1; 

				return depth;
			}
			ENDCG
		}
	}
}
