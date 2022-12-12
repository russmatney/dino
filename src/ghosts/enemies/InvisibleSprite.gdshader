shader_type canvas_item;

const float pi = 3.14156;

uniform float dist = 16.;
uniform float alpha : hint_range(0., 1.) = 1.;

void fragment() {
	vec2 backgroundUV = FRAGCOORD.xy * SCREEN_PIXEL_SIZE.xy;
	
	vec2 offsetR = vec2(dist * SCREEN_PIXEL_SIZE.x * cos(TIME * 2. * pi),        dist * SCREEN_PIXEL_SIZE.x * cos(TIME*0.7 * 2. * pi));
	vec2 offsetG = vec2(dist * SCREEN_PIXEL_SIZE.x * cos(1. + (TIME * 2. * pi)), dist * SCREEN_PIXEL_SIZE.x * cos(3. + (TIME*0.7 * 2. * pi)));
	vec2 offsetB = vec2(dist * SCREEN_PIXEL_SIZE.x * cos(TIME * 1.5 * pi),       dist * SCREEN_PIXEL_SIZE.x * cos(TIME*0.9 * 2. * pi));
	
	vec4 backColR = texture(SCREEN_TEXTURE, SCREEN_UV + offsetR);
	vec4 backColG = texture(SCREEN_TEXTURE, SCREEN_UV + offsetG);
	vec4 backColB = texture(SCREEN_TEXTURE, SCREEN_UV + offsetB);
	
	vec4 texCol = texture(TEXTURE, UV);
	
	COLOR = mix(texCol, texCol.a * vec4(backColR.r, backColG.g, backColB.b, 1.0), alpha);
}