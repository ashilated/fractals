shader_type canvas_item;

uniform float zoom = 4 ;
uniform float offset_x = 0.43;
uniform float offset_y = 0.381;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV - 0.5; 
	vec2 z = vec2(0);
	vec2 c = uv * zoom + vec2(offset_x, offset_y);
	float iterations = 0.0;
	int max_iterations = 100;
	
	for (int i = 0; i < max_iterations; i++) {
		z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
		if (length(z) > 2.0) {
			break;
		}
		iterations++;
	}
	float color = iterations / float(max_iterations);
	COLOR = vec4(pow(color, 2), pow(color * .3, 0.5), color, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
