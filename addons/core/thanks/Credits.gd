@tool
extends Control
class_name Credits

@export var credit_line_scene: PackedScene = preload("res://addons/core/thanks/CreditLine.tscn")
var credits_lines_container: VBoxContainer

var credits_scroll_container: ScrollContainer

var pause_scroll_delay = 2.0
var scroll_delay
var scroll_delay_per_line = 0.05
var since_last_scroll = 0

func _get_configuration_warnings():
	return U._config_warning({expected_nodes=[
		"CreditsScrollContainer", "CreditsLinesContainer"]})


var added_lines = []

## ready ############################################################

func _ready():
	scroll_delay = pause_scroll_delay

	credits_scroll_container = find_child("CreditsScrollContainer")
	assert(credits_scroll_container) #,"Expected ScrollContainer node")
	credits_lines_container = find_child("CreditsLinesContainer")
	assert(credits_lines_container) #,"Expected VBoxContainer node")

	# support ready creating a clean credits view
	for l in added_lines:
		credits_lines_container.remove_child(l)
		l.queue_free()

	added_lines = []

	for lines in get_credit_lines():
		var new_line = credit_line_scene.instantiate()
		new_line.text = "[center]\n"
		for line in lines:
			new_line.text += line + "\n"
		new_line.text += "[/center]"
		added_lines.append(new_line)
		credits_lines_container.add_child(new_line)

	DJ.resume_menu_song()

## input ############################################################

var scroll_held = Vector2.ZERO

func _unhandled_input(event):
	if Trolls.is_move_up(event):
		scroll_held = Vector2.UP
	elif Trolls.is_move_down(event):
		scroll_held = Vector2.DOWN
	if Trolls.is_move_released(event):
		scroll_held = Vector2.ZERO

## process ############################################################

func _process(delta):
	if scroll_held != Vector2.ZERO:
		match scroll_held:
			Vector2.UP: credits_scroll_container.scroll_vertical -= 30
			Vector2.DOWN: credits_scroll_container.scroll_vertical += 30
		return

	if scroll_delay <= 0:
		if since_last_scroll <= 0:
			credits_scroll_container.scroll_vertical += 1
			since_last_scroll = scroll_delay_per_line
		else:
			since_last_scroll -= delta
	else:
		scroll_delay -= delta

## credits ############################################################

var credits = [
	["A game"],
	["Created for the some game jam"],
	["Made in Godot, Aseprite, and Emacs"],
]

# overwrite in children
func get_credit_lines():
	return credits
