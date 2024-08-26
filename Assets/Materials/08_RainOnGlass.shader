Shader "CGL/08 - RainOnGlass"
{
	Properties
	{
		_Color("Colour", Color) = (1, 0, 0, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_RefractionMap1 ("Refraction Map 1", 2D) = "bump" {}
		_RefractionStrength2 ("Refraction Strength 2", float) = 8
		_RefractionMap2("Refraction Map 2", 2D) = "bump" {}
		_RefractionStrength1("Refraction Strength 1", float) = 8
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalRefractionStrength("Normal Refraction Strength", float) = 8
		_Speed ("Flow Speed 1 (XY)", Vector) = (0, 0, 0, 0)
	}

		SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent+3000"}

		GrabPass { "_ScreenGrab" }

		Pass
		{
			CGPROGRAM

			#pragma vertex vert // vertex shader --> use vert method
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vertexInput
			{
				float4 vertexPos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uvmain : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float2 uvbump : TEXCOORD2;
				float2 uvbump2 : TEXCOORD3;
				float2 uvnormal : TEXCOORD4;
			};

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _ScreenGrab;
			float4 _ScreenGrab_TexelSize;

			sampler2D _RefractionMap1;
			float4 _RefractionMap1_ST;
			float _RefractionStrength1;

			sampler2D _RefractionMap2;
			float4 _RefractionMap2_ST;
			float _RefractionStrength2;

			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			float _NormalRefractionStrength;

			float4 _Speed;

			v2f vert(vertexInput input)
			{
				v2f output;
				output.pos = UnityObjectToClipPos(input.vertexPos);
				output.uvmain = TRANSFORM_TEX(input.uv, _MainTex);
				output.uvgrab = ComputeGrabScreenPos(output.pos);
				output.uvbump = TRANSFORM_TEX(input.uv, _RefractionMap1);
				output.uvbump2 = TRANSFORM_TEX(input.uv, _RefractionMap2);
				output.uvnormal = TRANSFORM_TEX(input.uv, _NormalMap);
				return output;
			}

			float4 frag(v2f input) : COLOR
			{
				half2 bump = UnpackNormal(tex2D(_RefractionMap1, input.uvbump + _Speed.xy * _Time.x)).rg;
				float2 offset = bump * _ScreenGrab_TexelSize.xy * (_RefractionStrength1 * _RefractionStrength1);

				bump = UnpackNormal(tex2D(_RefractionMap2, input.uvbump2 + _Speed.zw * _Time.x)).rg;
				offset += bump * _ScreenGrab_TexelSize.xy * (_RefractionStrength2 * _RefractionStrength2);

				bump = UnpackNormal(tex2D(_NormalMap, input.uvnormal)).rg;
				offset += bump * _ScreenGrab_TexelSize.xy * (_NormalRefractionStrength * _NormalRefractionStrength);

				input.uvgrab.xy = offset * input.uvgrab.z + input.uvgrab.xy;
				half4 col = tex2Dproj(_ScreenGrab, input.uvgrab);
				col *= tex2D(_MainTex, input.uvmain);
				return col;
			}
			ENDCG
		}
	}
		FallBack "Standard"
}

//{
//	Properties
//	{
//		_Color ("Colour", Color) = (1, 1, 1, 1)
//		_MainTex ("Texture", 2D) = "white" {}
//		_NormalMap ("Normal Map", 2D) = "bump" {}
//	}
//
//	SubShader
//	{
//		Tags { "Queue" = "Transparent" "RenderType" = "Opaque"}
//
//		CGPROGRAM
//		#pragma surface surf Standard fullforwardshadows 
//		#pragma target 3.0
//
//		float3 RGBToHSV(float3 c)
//		{
//			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
//			float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g)); 
//			// lerp and step function built into hardware
//			// faster than if statement --> harder to read but better in code
//			// lerp fucntion --> step returns 0 or 1 depending on which value is greater so we get a or b value
//			// same as using if statement, but faster compilation
//			float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
//			float d = q.x - min(q.w, q.y);
//			float e = 1.0e-10;
//			return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
//		}
//
//		float3 HSVToRGB(float3 c)
//		{
//			float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
//			float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
//			return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
//		}
//
//
//		float4 _Color;
//		sampler2D _MainTex;
//		sampler2D _NormalMap;
//
//		struct Input
//		{
//			float2 uv_MainTex;
//			float2 uv_NormalMap;
//		};
//
//		void surf(Input IN, inout SurfaceOutputStandard o) //color is the output of the method
//		{
//			float4 clr = tex2D(_MainTex, IN.uv_MainTex); 
//			o.Albedo = HSVToRGB(c) * _Color;
//			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
//			o.Alpha = clr.a;
//		}
//
//		ENDCG
//	}
//	FallBack "Standard"
//}
