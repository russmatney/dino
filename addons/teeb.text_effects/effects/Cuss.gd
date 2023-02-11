@tool
extends RichTextEffect


# Syntax: [cuss][/cuss]
var bbcode = "cuss"

var VOWELS = ["a".unicode_at(0), "e".unicode_at(0), "i".unicode_at(0), "o".unicode_at(0), "u".unicode_at(0),
	"A".unicode_at(0), "E".unicode_at(0), "I".unicode_at(0), "O".unicode_at(0), "U".unicode_at(0)]
var CHARS = ["&".unicode_at(0), "$".unicode_at(0), "!".unicode_at(0), "@".unicode_at(0), "*".unicode_at(0), "#".unicode_at(0), "%".unicode_at(0)]
var SPACE = " ".unicode_at(0)

var _was_space = false


func _process_custom_fx(char_fx):
	var c = char_fx.glyph_index

	if not _was_space and not char_fx.relative_index == 0 and not c == SPACE:
		var t = char_fx.elapsed_time + char_fx.glyph_index * 10.2 + char_fx.glyph_index * 2
		t *= 4.3
		if c in VOWELS or sin(t) > 0.0:
			char_fx.glyph_index = CHARS[int(t) % len(CHARS)]

	_was_space = c == SPACE

	return true
