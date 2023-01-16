shader_type canvas_item;

uniform vec4 outline: hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 accent: hint_color = vec4(1.0, 1.0, 1.0, 1.0);

float luminance(vec4 colour) {
	return 1.0 - sqrt(0.299*colour.r*colour.r + 0.587*colour.g*colour.g + 0.114*colour.b*colour.b);
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if(color.a > 0.) {
		float lum = luminance(color);
		if(lum > 0.5) {
			color = outline;
		} else {
			color = accent;
		}
	}
	
	COLOR = color;
}