@tool
extends Control

## reload button #######################################################################

var editor_interface
func _on_reload_plugin_button_pressed():
	if Engine.is_editor_hint():
		Log.pr(&"Reloading trolley plugin ----------------------------------")
		editor_interface.set_plugin_enabled("trolley", false)
		editor_interface.set_plugin_enabled("trolley", true)
		editor_interface.set_main_screen_editor("Trolley")
		Log.pr(&"Reloaded trolley plugin -----------------------------------")
	else:
		Log.pr("Trolley UI Reload Not impled outside of editor")


## ready #######################################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	update_joypads()


## joypads #######################################################################

@onready var joypad_label = $%Joypads
@onready var joypad_list = $%JoypadList

func new_joypad_label(jp_id):
	var label = "[center]%s: %s[/center]" % [jp_id, Input.get_joy_name(jp_id)]
	var lbl = RichTextLabel.new()
	lbl.bbcode_enabled = true
	lbl.text = label
	lbl.scroll_active = false
	lbl.fit_content = true
	joypad_list.add_child(lbl)

func update_joypads():
	var jpads = Input.get_connected_joypads()

	if len(jpads) > 0:
		joypad_label.text = "[center]%s[/center]" % str(len(jpads), " Joypads connected")

	Log.pr("connected joypads", jpads)

	for ch in joypad_list.get_children():
		ch.queue_free()
	jpads.map(new_joypad_label)


## process #######################################################################

@onready var active_controls_label = $%ActiveControlsLabel

func _process(_delta):
	var label = "[center]Active Controls:[/center]"

	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var trolley_move_vector = Trolley.move_vector()

	label += "\nmove vector: %s, \ntrolley move vector: %s" % [
		Log.to_pretty(move_vector), Log.to_pretty(trolley_move_vector)
		]

	active_controls_label.text = Log.to_pretty(label)


## unhandled input #######################################################################

@onready var unhandled_input_list = $%UnhandledInputList

var n = 15
# limit the input list to `n` inputs
func limit_input_list():
	var children = unhandled_input_list.get_children()
	if len(children) > n:
		for i in range(0, len(children) - n):
			# HEY NOW - this could delete extra children depending on queue_free's asyncyness
			# but it's fine, we're just trying to see the latest keypresses
			unhandled_input_list.get_children()[i].queue_free()


func new_input_label(event):
	var axs = Trolley.actions_for_input(event)
	var label = "[center]raw: %s[/center]" % Log.to_pretty(event)
	for ax in axs:
		label += "\n\t%s: %s" % [
			Log.to_pretty(ax.key_str) if "key_str" in ax else Log.to_pretty(ax.btn_idx),
			Log.to_pretty(ax.action_label),
			]

	var lbl = RichTextLabel.new()
	lbl.bbcode_enabled = true
	lbl.text = label
	lbl.scroll_active = false
	lbl.fit_content = true
	unhandled_input_list.add_child(lbl)


func _unhandled_input(event):
	new_input_label(event)
	limit_input_list()
