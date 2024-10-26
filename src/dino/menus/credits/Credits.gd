@tool
extends CanvasLayer
class_name Credits

@export var credit_line_scene: PackedScene = preload("res://src/dino/menus/credits/CreditLine.tscn")
@export var credit_header_scene: PackedScene = preload("res://src/dino/menus/credits/CreditHeader.tscn")
@onready var credits_lines_container: VBoxContainer = $%CreditsLinesContainer
@onready var credits_scroll_container: ScrollContainer = $%CreditsScrollContainer

var pause_scroll_delay = 2.0
@onready var scroll_delay = pause_scroll_delay
var scroll_delay_per_line = 0.05
var since_last_scroll = 0

var added_lines = []

## ready ############################################################

func _on_button_pressed():
	Navi.nav_to_main_menu()

func _ready():
	credits_scroll_container.scroll_vertical = 0
	scroll_delay = pause_scroll_delay

	# clear lines
	for l in added_lines:
		credits_lines_container.remove_child(l)
		l.queue_free()

	added_lines = []

	for lines in get_credit_lines():
		# var header_lines = []
		# var body_lines = []
		var first_line
		for l in lines:
			if l != "":
				first_line = l
				break

		var line_label
		if first_line.begins_with("# "):
			line_label = credit_header_scene.instantiate()
		else:
			line_label = credit_line_scene.instantiate()

		line_label.text = "[center]\n"
		for line in lines:
			if line == first_line:
				line = line.trim_prefix("# ")
			line_label.text += line + "\n"
		line_label.text += "[/center]"
		added_lines.append(line_label)
		credits_lines_container.add_child(line_label)

## input ############################################################

var scroll_direction = Vector2.ZERO

func _unhandled_input(event):
	var move_vec = Trolls.move_vector()
	if Trolls.is_move_up(event) or move_vec.y < -0.2:
		scroll_direction = Vector2.UP
	elif Trolls.is_move_down(event) or move_vec.y > 0.2 or Trolls.is_close(event):
		scroll_direction = Vector2.DOWN
	elif Trolls.is_move_released(event) or Trolls.is_close_released(event):
		scroll_direction = Vector2.ZERO

## process ############################################################

func _process(delta):
	if scroll_direction != Vector2.ZERO:
		match scroll_direction:
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

func get_credit_lines():
	return DinoCredits.get_credits()
