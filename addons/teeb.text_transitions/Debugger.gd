@tool
extends Control


var _time:float = 0.0
var _reverse:bool = false
var _all_at_once:bool = false


@export var info:String = """Press 1 to 'fade in' all effects. # (String, MULTILINE)
Press 2 to 'fade out' all effects.
Or, simply mess with the following slider and toggles."""
@export var time:float = 0.0 : get = _get_time, set = _set_time # (float, 0.0, 1.0)
@export var reverse: bool:bool = false : get = _get_reverse, set = _set_reverse
@export var all_at_once: bool:bool = false : get = _get_all_at_once, set = _set_all_at_once


func _process(delta):
	if Input.is_key_pressed(KEY_1):
		for key in TextTransitionSettings.transitions:
			TextTransitionSettings.transitions[key].fade_in()
	elif Input.is_key_pressed(KEY_2):
		for key in TextTransitionSettings.transitions:
			TextTransitionSettings.transitions[key].fade_out()


func _set_time(new_time):
	_time = new_time
	for key in TextTransitionSettings.transitions:
		TextTransitionSettings.transitions[key].time = new_time


func _get_time():
	return _time


func _set_reverse(new_reverse):
	_reverse = new_reverse
	for key in TextTransitionSettings.transitions:
		TextTransitionSettings.transitions[key].reverse = new_reverse


func _get_reverse():
	return _reverse


func _set_all_at_once(new_aao):
	_all_at_once = new_aao
	for key in TextTransitionSettings.transitions:
		TextTransitionSettings.transitions[key].all_at_once = new_aao


func _get_all_at_once():
	return _all_at_once
