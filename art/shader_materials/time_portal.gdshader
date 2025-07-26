shader_type canvas_item;

void vertex() {
	//UV.x += sin(TIME) * 1.0;
	//UV.y += cos(TIME) * 1.0;
	//UV.y += sin(UV.x*50.0 + TIME*2.0)*5.0;
	//UV.x += cos(UV.y)*5.0;
	//UV.y += sin(UV.x*50.0)*5.0;
	//UV.x += cos(UV.y)/5.0;
}

void fragment() {
	vec4 input_color = texture(TEXTURE, vec2(UV.x*sin(UV.x), UV.y + sin(UV.x)));
	COLOR = input_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
