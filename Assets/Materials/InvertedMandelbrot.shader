Shader "Fractals/InvertedMandelbrot"
{
	Properties
	{
		_xPos ("X Position", float) = 0
		_yPos ("Y Position", float) = 0
		_Zoom ("Zoom", float) = 0
		_Color1 ("Color 1", Color) = (0,0,0,1)
		_Color2 ("Color 2", Color) = (1,1,1,1)
		_Iterations ("Iterations", Range(1,1024)) = 300
		_Radius ("Radius", Range(0,2)) = 2
		_Smooth ("Smooth", int) = 1
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			float _xPos, _yPos, _Zoom;
			float4 _Color1, _Color2;
			float _Iterations;
			float _Radius;
			float _Smooth;

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			//Vertex Shader
			v2f vert (appdata v){
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			//Fragment Shader
			fixed4 frag (v2f i) : SV_Target{
				float max = _Iterations;
				float r2;
				float zoom2 = pow(2,_Zoom);
				float x  = 0;
				float y  = 0;
				float x0 =(((1-i.uv.x)-0.5)/zoom2 + _xPos);
				float y0 =(((1-i.uv.y) -0.5)/zoom2 + _yPos);

				if(_Smooth == 1){
					r2 = 100;
				}else{
					r2 = _Radius*_Radius;
				}

				float it = 0;
				while((x*x + y*y < r2) && it<max){
					float xtemp = x*x - y*y + x0/(x0*x0+y0*y0);
					y = 2*x*y - y0/(x0*x0 + y0*y0);
					x = xtemp;

					it++;
				}
				if(_Smooth = 1 && it < max){
					float log_zn = log(x*x + y*y)/2;
					float nu = log(log_zn / log(2)) / log(2);
					it = it+1-nu;
				}
				float value = (it/max);
				return _Color1 + (_Color2 - _Color1) * value;
			}
			ENDCG
		}
	}
}
