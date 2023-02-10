@tool
extends RichTextEffect


# Syntax: [heart scale=1.0 freq=8.0][/heart]
var bbcode = "heart"

var HEART = "♡".unicode_at(0)
var TO_CHANGE = ["o".unicode_at(0), "O".unicode_at(0), "a".unicode_at(0), "A".unicode_at(0)]

func _process_custom_fx(char_fx):
	var scale:float = char_fx.env.get("scale", 16.0)
	var freq:float = char_fx.env.get("freq", 2.0)

	var x =  char_fx.glyph_index / scale - char_fx.elapsed_time * freq
	var t = abs(cos(x)) * max(0.0, smoothstep(0.712, 0.99, sin(x))) * 2.5;
	char_fx.color = lerp(char_fx.color, lerp(Color.BLUE, Color.RED, t), t)
	char_fx.offset.y -= t * 4.0

	var c = char_fx.glyph_index
	if char_fx.offset.y < -1.0:
		if char_fx.glyph_index in TO_CHANGE:
			char_fx.glyph_index = HEART

	return true
