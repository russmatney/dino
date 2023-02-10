@tool
extends RichTextEffect


# Syntax: [uwu][/uwu]
var bbcode = "uwu"


var r = "r".unicode_at(0)
var R = "R".unicode_at(0)
var l = "l".unicode_at(0)
var L = "L".unicode_at(0)

var w = "w".unicode_at(0)
var W = "W".unicode_at(0)


func _process_custom_fx(char_fx):
	match char_fx.character:
		r, l: char_fx.character = w
		R, L: char_fx.character = W
	return true
