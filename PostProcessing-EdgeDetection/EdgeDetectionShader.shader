Shader "Custom/EdgeDetectionShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Threshold("Threshold", float) = 0.01
        _EdgeColor("Edge color", Color) = (0,0,0,1)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			sampler2D _CameraDepthNormalsTexture;
			float4 _MainTex_TexelSize; 
			half4 _EdgeColor; 
			half _Threshold; 

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 GetPixelValue(in float2 uv)
			{
				half3 normal; 
				float depth; 
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, uv), depth, normal);
				return fixed4(normal, depth); 
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 or_value = GetPixelValue(i.uv);
				float2 offsets[8] = {
					float2(-1,-1),
					float2(-1,0),
					float2(-1,1), 
					float2(0,-1),
					float2(0,1), 
					float2(1,-1), 
					float2(1,0), 
					float2(1,1)
				};
				fixed4 sampled_value = fixed4(0,0,0,0);
				for(int j = 0; j<8;j++)
				{
					sampled_value += GetPixelValue(i.uv + offsets[j]*_MainTex_TexelSize.xy); 
				}

				sampled_value /= 8; 

				return lerp(col, _EdgeColor, step(_Threshold, length(or_value - sampled_value)));
			}
			ENDCG
		}
	}
}
