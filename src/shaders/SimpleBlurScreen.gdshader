shader_type canvas_item;

uniform float lod: hint_range(0.0, 5) = 0.0;
uniform float grayscale: hint_range(0.0, 5) = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod);
	
	if (grayscale > 0.01) {
		float gray = (COLOR.r + COLOR.g + COLOR.b) / 3.0 * grayscale;
		COLOR = vec4(gray, gray, gray, COLOR.a);
	}

}
