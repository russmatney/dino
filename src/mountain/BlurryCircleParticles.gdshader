shader_type canvas_item;

uniform float v = 1.0; 
uniform float size = 5.0;
uniform float lod: hint_range(0.0, 5) = 0.0;

void fragment() {
	vec4 c = textureLod(TEXTURE, UV, 0.0);
	for (float x = -size; x < size; x++)
	{
		for (float y = -size; y < size; y++)
		{
			if (x*x + y*y > size*size){continue;}
			vec4 new_c = textureLod(TEXTURE, UV+TEXTURE_PIXEL_SIZE*vec2(x, y), lod);
			if (length(new_c) >length(c)){
				c = new_c;
			}
		}
	}
	COLOR = c;
	
}