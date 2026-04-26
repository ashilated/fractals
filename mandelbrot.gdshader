shader_type canvas_item;

uniform float zoom = 4;
uniform float power = 2;
uniform vec2 offset = vec2(0, 0);
uniform vec4 color1 = vec4(1, 1, 1, 1);
uniform vec4 color2 = vec4(0, 0, 0, 1);
uniform vec4 accent = vec4(0.5, 0, 0.5, 1);
uniform float accent_intensity = 5;
uniform int max_iterations = 100;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV - 0.5; 
	vec2 z = vec2(0);
	vec2 c = uv * zoom + offset;
	float iterations = 0.0;
	
	for (int i = 0; i < max_iterations; i++) {
		z = vec2(pow(z.x * z.x + z.y * z.y, power / 2.0) * cos(power * atan(z.y, z.x)),
				 pow(z.x * z.x + z.y * z.y, power / 2.0) * sin(power * atan(z.y, z.x))) + c;
		if (length(z) > 4.0) {
			break;
		}
		iterations++;
	}
	//if (iterations > 40.0) {
	//	COLOR = mix(mix(vec4(1,0,0,1), accent, iterations / float(max_iterations) * accent_intensity), color2, iterations / float(max_iterations));
	 //} else {
		COLOR = mix(mix(color1, accent, iterations / float(max_iterations) * accent_intensity), color2, iterations / float(max_iterations));
	//}
	
	//COLOR = vec4(cos(PI * color1.r * iterations)/2.0,
		//cos(PI * color1.g * iterations)/2.0,
		//cos( PI * color1.b * iterations)/2.0,
		//1
		//);
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
