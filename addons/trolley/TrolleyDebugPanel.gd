@tool
extends Control


func _ready():
	if Engine.is_editor_hint():
		request_ready()


## reload button #######################################################################

var editor_interface
func _on_reload_plugin_button_pressed():
	if Engine.is_editor_hint():
		Debug.pr(&"Reloading trolley plugin ----------------------------------")
		editor_interface.set_plugin_enabled("trolley", false)
		editor_interface.set_plugin_enabled("trolley", true)
		editor_interface.set_main_screen_editor("Trolley")
		Debug.pr(&"Reloaded trolley plugin -----------------------------------")
	else:
		Debug.pr("Trolley UI Reload Not impled outside of editor")



## process #######################################################################

@onready var active_controls_label = $%ActiveControlsLabel

func _process(_delta):
	var label = "[center]Active Controls:[/center]"

	# var jpads = Input.get_connected_joypads()
	# Debug.pr("connected joypads", jpads)
	# for jp in jpads:
	# 	Debug.pr("jpad", jp, Input.get_joy_name(jp))

	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var trolley_move_vector = Trolley.move_vector()

	# Debug.pr("move vector", move_vector, "trolley move vector", trolley_move_vector)
	# Debug.pr("anything pressed?", Input.is_anything_pressed())

	label += "\nmove vector: %s, \ntrolley move vector: %s" % [
		Debug.to_pretty(move_vector), Debug.to_pretty(trolley_move_vector)
		]

	active_controls_label.text = Debug.to_pretty(label)


## unhandled input #######################################################################

@onready var unhandled_input_list = $%UnhandledInputList
var n = 15

func new_input_label(event):
	var lbl = RichTextLabel.new()
	lbl.bbcode_enabled = true
	lbl.text = "[center]%s[/center]" % Debug.to_pretty(event)
	lbl.scroll_active = false
	lbl.fit_content = true
	unhandled_input_list.add_child(lbl)

	var children = unhandled_input_list.get_children()
	if len(children) > n:
		for i in range(0, len(children) - n):
			# HEY NOW - this could delete extra children depending on queue_free's asyncyness
			# but it's fine, we're just trying to see the latest keypresses
			unhandled_input_list.get_children()[i].queue_free()

func _unhandled_input(event):
	Debug.pr(event)
	new_input_label(event)
