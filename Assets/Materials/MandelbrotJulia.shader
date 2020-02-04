Shader "Fractals/MandelbrotJulia"
{
	Properties
	{
		_xPos ("X Position", float) = 0
		_yPos ("Y Position", float) = 0
		_Zoom ("Zoom", float) = 0
		_Color1 ("Color 1", Color) = (1,0.3,0.3,1)
		_Color2 ("Color 2", Color) = (0.3,1,0.3,1)
		_Type ("Type", Range(0,1)) = 0
		_Iterations ("Iterations", Range(1,1024)) = 300
		_Radius ("Radius", Range(0,2)) = 2
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
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_nicest
			
			#include "UnityCG.cginc"

			float _xPos, _yPos, _Zoom;
			float4 _Color1, _Color2;
			float _Type;
			float _Iterations;
			float _Radius;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float x,y,x0,y0;
				fixed4 color;
				float zoom2 = pow(2,_Zoom);

				x  =(((1-i.uv.x) -0.5)/zoom2 + _xPos)*_Type;
				y  =(((1-i.uv.y) -0.5)/zoom2 + _yPos)*_Type;
				//x0 =(((1-i.uv.x + sin((_Time.z+i.uv.y)*10)*0.01f) -0.5)/zoom2 + _xPos)*(1-_Type) + (-0.4)*_Type;
				x0 =(((1-i.uv.x)-0.5)/zoom2 + _xPos)*(1-_Type) + (-0.4)*_Type;
				//x0 =((1-i.uv.x + abs((((i.uv.y)*5)%2)-1)*0.1-0.5)/zoom2 + _xPos)*(1-_Type) + (-0.4)*_Type;
				//y0 =(((1-i.uv.y+ sin((_Time.z+i.uv.x)*10)*0.01f) -0.5)/zoom2 + _yPos)*(1-_Type) + (0.6)*_Type;
				y0 =(((1-i.uv.y) -0.5)/zoom2 + _yPos)*(1-_Type) + (0.6)*_Type;
				//y0 =((1-i.uv.y + abs((((i.uv.x)*5)%2)-1)*0.1f-0.5)/zoom2 + _yPos)*(1-_Type) + (-0.4)*_Type;

				float it = 0;
				float max = _Iterations;
				while((x*x + y*y < _Radius*_Radius) && it<max){
					float xtemp = x*x - y*y + x0;
					y = 2*x*y + y0;
					x = xtemp;
					it++;
				}

				float value = (it/max);
				//color = float4(0, , value/3 , 1);
				//color = value*_Color1 + (1-value)*_Color2;
				color = _Color1 + (_Color2-_Color1) * value;
				return color;
			}
			ENDCG
		}
	}
}
