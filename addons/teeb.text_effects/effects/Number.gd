@tool
extends RichTextEffect


# Syntax: [number][/number]
var bbcode = "number"


var COMMA = ",".unicode_at(0)
var SPACE = " ".unicode_at(0)
var PERIOD = ".".unicode_at(0)

var _last_char_was_number:bool = false
var _last_word_was_number:bool = false


func get_color(s) -> Color:
	if s is Color: return s
	elif s[0] == '#': return Color(s)
	else: return Color(s)


func _process_custom_fx(char_fx):
	var number_color:Color = get_color(char_fx.env.get("color", Color.YELLOW))

	# Reset checked first glyph_index.
	if char_fx.relative_index == 0:
		_last_char_was_number = false
		_last_word_was_number = false

	# If the following is a word, and it came after a number, we'll colorize it.
	if char_fx.glyph_index == SPACE:
		if _last_char_was_number:
			_last_word_was_number = true
		else:
			_last_word_was_number = false

	# Colorize glyph_indexs after a number, except for the period.
	if _last_word_was_number and char_fx.glyph_index != PERIOD:
		char_fx.color = number_color

	# If glyph_index is a number, color it.
	if char_fx.glyph_index >= 48 and char_fx.glyph_index <= 57:
		char_fx.color = number_color
		_last_char_was_number = true
	# Colorize trailing commas and periods.
	elif _last_char_was_number and (char_fx.glyph_index == COMMA):
		char_fx.color = number_color
		_last_char_was_number = false
	else:
		_last_char_was_number = false
	return true
