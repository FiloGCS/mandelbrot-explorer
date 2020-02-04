using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FractalWindow : MonoBehaviour {

	public Dropdown ShaderDropdown;
	public List<Shader> shaders;

	public InputField xPosField;
	public InputField yPosField;
	public InputField zoomField;
	//public Slider typeSlider;
	public Slider iterationsSlider;
	public Slider radiusSlider;
	public Text numIterationsLabel;
	public Text radiusLabel;

	//Colorpicker1 +++
	public Slider R1Slider;
	public Text R1Label;
	public Slider G1Slider;
	public Text G1Label;
	public Slider B1Slider;
	public Text B1Label;
	public Image Viewer1;
	//Colorpicker2 +++
	public Slider R2Slider;
	public Text R2Label;
	public Slider G2Slider;
	public Text G2Label;
	public Slider B2Slider;
	public Text B2Label;
	public Image Viewer2;

	public float scrollSpeed = 1;

	private Material mat;

	// Use this for initialization
	void Start () {
		mat = this.GetComponent<Renderer> ().material;
	}

	// Update is called once per frame
	void Update () {



		//Zoom level
		float zoom;
		float.TryParse(zoomField.text, out zoom);
		zoom += Input.GetAxis ("Mouse ScrollWheel")*2;
		zoomField.text = zoom.ToString();
		this.mat.SetFloat("_Zoom", zoom);

		//Position
		float xPos;
		float.TryParse(xPosField.text, out xPos);
		float hInput = Input.GetAxis ("Horizontal");
		if (Mathf.Abs (hInput) > 0.1 && Mathf.Abs (hInput) <= 1) {
			xPos += Input.GetAxis ("Horizontal") * 0.02f / Mathf.Pow(2,zoom) * Time.deltaTime * scrollSpeed;
		}
		if(!xPosField.isFocused)
			xPosField.text = xPos.ToString();
		this.mat.SetFloat("_xPos", xPos);

		float yPos;
		float.TryParse(yPosField.text, out yPos);
		float vInput = Input.GetAxis ("Vertical");
		if(Mathf.Abs(vInput) > 0.1 && Mathf.Abs(vInput) <=1)
			yPos += Input.GetAxis ("Vertical") * 0.02f / Mathf.Pow(2,zoom) * Time.deltaTime * scrollSpeed;

		if(!yPosField.isFocused)
			yPosField.text = yPos.ToString();
		this.mat.SetFloat("_yPos", yPos);

		//Radius
		float radius;
		radius = radiusSlider.value;
		if (radius <= 2 && radius >= 0) {
			this.mat.SetFloat ("_Radius", radius);
		}
		radiusLabel.text = radius.ToString ();

		//Number of iterations
		float iterations;
		iterations = Mathf.Pow(2,iterationsSlider.value);
		if(iterations <= 1024 && iterations >=0){
			this.mat.SetFloat ("_Iterations", iterations);
		}

		numIterationsLabel.text = ((int) iterations).ToString();
		Color green = new Vector4(0.5f, 1f, 0.5f, 1f);
		Color red = new Vector4(1f, 0.3f, 0.3f, 1f);
		float t = iterations / 1024f;
		Color labelColor = t * red + (1 - t) * (green);
		numIterationsLabel.color = labelColor;

		//Color1
		R1Label.text = ((int) R1Slider.value).ToString();
		G1Label.text = ((int) G1Slider.value).ToString();
		B1Label.text = ((int) B1Slider.value).ToString();
		Color color1 = new Vector4 (R1Slider.value / 255f,G1Slider.value / 255f,B1Slider.value / 255f,1);
		Viewer1.color = color1;
		mat.SetColor ("_Color1", color1);

		//Color2
		R2Label.text = ((int) R2Slider.value).ToString();
		G2Label.text = ((int) G2Slider.value).ToString();
		B2Label.text = ((int) B2Slider.value).ToString();
		Color color2 = new Vector4 (R2Slider.value / 255f,G2Slider.value / 255f,B2Slider.value / 255f,1);
		Viewer2.color = color2;
		mat.SetColor ("_Color2", color2);

	}

	public void OnChangeShader(){
		int currentShader = ShaderDropdown.value;
		if (currentShader >= 0 && currentShader < shaders.Count) {
			mat.shader = shaders [currentShader];
		} else {
			print ("Ha ocurrido un error al seleccionar un shader. Elemento no encontrado.");
		}

		switch (currentShader) {
		case 0://Mandelbrot
			break;	
		case 1://Julia
			break;	
		default:
			break;
		}

	}

}
