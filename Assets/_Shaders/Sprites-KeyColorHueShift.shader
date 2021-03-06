Shader "Sprites/KeyColorHueShift"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		_Source0 ("Source0", Color) = (1,0,0,1)
		_Source1 ("Source1", Color) = (0,1,0,1)
		_Source2 ("Source2", Color) = (0,0,1,1)
		_Out0 ("Out0", Color) = (1,0,0,1)
		_Out1 ("Out1", Color) = (0,1,0,1)
		_Out2 ("Out2", Color) = (0,0,1,1)
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest Always
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile DUMMY PIXELSNAP_ON
			#include "UnityCG.cginc"
			#include "Color.cginc"
			
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Color;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			fixed4 _Source0;
			fixed4 _Source1;
			fixed4 _Source2;
			fixed4 _Out0;
			fixed4 _Out1;
			fixed4 _Out2;

			fixed4 frag(v2f IN) : COLOR
			{
				fixed4 inputColor = tex2D(_MainTex, IN.texcoord) * IN.color;
				if (distance( inputColor, _Source0) < 0.1f) {
					return float4(HueShiftRGB(_Out0, (_SinTime.x + _SinTime.y + _SinTime.z + _SinTime.w*3)*0.02), 1);
				} 
				else if (distance( inputColor, _Source1) < 0.1f) {
					return float4(HueShiftRGB(_Out1, (_SinTime.x + _SinTime.y + _SinTime.z + _SinTime.w*3)*0.02), 1);
				} 
				else if (distance( inputColor, _Source2) < 0.1f) {
					return float4(HueShiftRGB(_Out2, (_SinTime.x + _SinTime.y + _SinTime.z + _SinTime.w*3)*0.02), 1);
				}
				else {
					return inputColor;
				}
			}
		ENDCG
		}
	}
}
