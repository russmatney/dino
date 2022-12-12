shader_type canvas_item;


uniform float red_displacement : hint_range(-1.0,1.0) = 0.0;
uniform float green_displacement : hint_range(-1.0,1.0) = 0.0;
uniform float blue_displacement : hint_range(-1.0,1.0) = 0.0;
uniform float ghost : hint_range(0.0, 1.0) = 0.0;
uniform float intensity : hint_range(0.0,1.0) = 0.0;
uniform float scan_effect : hint_range(0.0,1.0) = 0.0;
uniform float distortion_effect : hint_range(0.0,1.0) = 0.0;
uniform float negative_effect : hint_range(0.0,1.0) = 0.0;


void fragment()
{
	vec4 baseTexture = texture(TEXTURE, UV);
	vec4 color1 = texture(TEXTURE, UV+vec2(sin(TIME*0.2*intensity), tan(UV.y)));
	COLOR = (1.0-scan_effect)*baseTexture*0.75 + scan_effect*color1;
	
	vec4 color2 = texture(TEXTURE, UV+vec2(fract(TIME*0.01*intensity), cos(fract(TIME*intensity)*10.0)));
	COLOR = COLOR + ((1.0-distortion_effect)*baseTexture*0.75 + distortion_effect*color2);
	
	vec4 color3 = texture(TEXTURE, UV + vec2(fract(TIME*0.1*intensity), tan(TIME*0.02*intensity) ));
	COLOR = COLOR - ((1.0-negative_effect)*baseTexture*0.5 + negative_effect*color3);
	
	COLOR.r = (1.0-red_displacement)*baseTexture.r + red_displacement*texture(TEXTURE, UV-vec2(sin(TIME*0.1*intensity) + 0.2, 0.1)).r;
	COLOR.g = (1.0-green_displacement)*baseTexture.g +  green_displacement*texture(TEXTURE, UV+vec2(- 0.2, sin(TIME*0.1*intensity))).g;
	COLOR.b = (1.0-blue_displacement)*baseTexture.b + blue_displacement*texture(TEXTURE, UV+vec2(sin(TIME*0.1*intensity) + 0.2, 0.1)).b;
	COLOR = COLOR + texture(TEXTURE, UV + UV*ghost)*ghost;
}