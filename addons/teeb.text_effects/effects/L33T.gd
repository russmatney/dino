@tool
extends RichTextEffect

# Syntax: [l33t][/l33t]
var bbcode = "l33t"


var leet = {
	"L".unicode_at(0): "1".unicode_at(0),
	"l".unicode_at(0): "1".unicode_at(0),
	"I".unicode_at(0): "1".unicode_at(0),
	"i".unicode_at(0): "1".unicode_at(0),
	"E".unicode_at(0): "3".unicode_at(0),
	"e".unicode_at(0): "3".unicode_at(0),
	"T".unicode_at(0): "7".unicode_at(0),
	"t".unicode_at(0): "7".unicode_at(0),
	"S".unicode_at(0): "5".unicode_at(0),
	"s".unicode_at(0): "5".unicode_at(0),
	"A".unicode_at(0): "4".unicode_at(0),
	"a".unicode_at(0): "4".unicode_at(0),
	"O".unicode_at(0): "0".unicode_at(0),
	"o".unicode_at(0): "0".unicode_at(0),
}


func _process_custom_fx(char_fx):
	if char_fx.character in leet:
		char_fx.character = leet[char_fx.character]
	return true
