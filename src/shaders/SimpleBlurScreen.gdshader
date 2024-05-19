shader_type canvas_item;

uniform float lod: hint_range(0.0, 5) = 0.0;
uniform float grayscale: hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod);

	float gray = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	float r_diff = (gray - COLOR.r) * grayscale;
	float g_diff = (gray - COLOR.g) * grayscale;
	float b_diff = (gray - COLOR.b) * grayscale;

	COLOR = vec4(COLOR.r + r_diff, COLOR.g + g_diff, COLOR.b + b_diff, COLOR.a);
}
