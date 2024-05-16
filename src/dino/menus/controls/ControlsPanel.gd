@tool
extends PanelContainer

## vars ###############################################3

@onready var edit_action_scene = preload("res://src/menus/controls/EditActionRow.tscn")
@onready var action_rows = $%EditActionRows
@onready var reset_controls_button = $%ResetControlsButton

var displayed_actions = [
	"ui_accept", "ui_undo", "pause", "close", "restart",
	# "ui_up", "ui_down", "ui_left", "ui_right",
	]

## ready ###############################################3

func _ready():
	render_action_rows()
	reset_controls_button.pressed.connect(on_reset_controls_pressed)

## render ###############################################3

func render_action_rows():
	U.remove_children(action_rows)
	for action in displayed_actions:
		var row = edit_action_scene.instantiate()
		row.edit_pressed.connect(on_edit_pressed.bind(row))
		row.action_name = action
		action_rows.add_child(row)

	for row in action_rows.get_children():
		row.set_focus()
		break

## on edit

func on_edit_pressed(row):
	for r in action_rows.get_children():
		if r != row:
			r.clear_editing_unless(row)

## reset controls ###############################################3

func on_reset_controls_pressed():
	Log.pr("resetting controls!")
	InputHelper.reset_all_actions()
	render_action_rows()
