@tool
extends "res://addons/teeb.text_transitions/transitions/TransitionBase.gd"


# Syntax: [embers color][/embers]
var bbcode = "embers"


var EMBER = GlyphConverter.ord(".")


func _process_custom_fx(char_fx):
	var tween_data = get_tween_data(char_fx)
	var ember_as_glyph_index = GlyphConverter.char_to_glyph_index(char_fx.font, EMBER)
	
	if tween_data.time == 1.0:
		return true
	var scale = char_fx.env.get("scale", 16.0)
	var clr1 = char_fx.env.get("color")
	if clr1 == null:
		clr1 = Color.RED
	else:
		clr1 = tween_data.get_color(clr1)
	var clr2 = clr1
	clr2.a = 0.0
	
	var t = tween_data.get_t(char_fx.range.x)
	var t2 = tween_data.get_t(char_fx.range.x+1)
	var r = get_rand(char_fx) * PI * 2.0
	# Comment out the next three lines to have it be the letter itself.
	if t != t2:
		char_fx.glyph_index = ember_as_glyph_index
		char_fx.offset -= Vector2(16, 8)
	char_fx.color = lerp(char_fx.color, lerp(clr1, clr2, t), t)
	char_fx.offset += Vector2(cos(r) * scale * t, sin(r) * scale * t)
	return true
