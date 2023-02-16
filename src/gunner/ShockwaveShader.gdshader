shader_type canvas_item;
// based on: https://www.youtube.com/watch?v=SCHdglr35pk

uniform vec2 center = vec2(0.5, 0.5);
uniform float force = 0.1;
uniform float size = 0.3;
uniform float thickness = 0.1;
uniform float color_offset = 0.01;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;

	vec2 scaledUV = SCREEN_UV - vec2(0.5, 0.0) / vec2(ratio, 1.0) + vec2(0.5, 0.0);

	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) *
smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));

	vec2 disp = normalize(scaledUV - center) * force * mask;

	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + disp);

	// COLOR.r = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + color_offset, SCREEN_UV.y) - disp).r;
	// COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV - disp).g;
	// COLOR.b = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - color_offset, SCREEN_UV.y) - disp).b;

	// debugger helpers
	// COLOR = vec4(UV - disp, 0.0, 1.0);
	COLOR.rgb = vec3(mask);
}
