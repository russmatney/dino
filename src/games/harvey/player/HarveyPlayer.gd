class_name HarveyPlayer
extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var action_detector = $ActionDetector

## ready ###########################################################

func _ready():
	machine.transitioned.connect(on_transit)

	Cam.request_camera({player=self})

############################################################
# process

func _process(_delta):
	update_action_label()
	point_arrow()

func point_arrow():
	if action_detector.actions.size() == 0:
		action_arrow.set_visible(false)
		return
	action_arrow.set_visible(true)

	var ax = action_detector.nearest_action()
	if ax and ax.source:
		var rot = get_angle_to(ax.source.get_global_position()) + (PI / 2)
		action_arrow.set_rotation(rot)

## _input ###########################################################

# overwritten in subclass
func _unhandled_input(event):
	if Trolls.is_action(event):
		action_detector.execute_current_action()

## machine ###########################################################

@onready var machine = $Machine
@onready var state_label = $StateLabel

func on_transit(_new_state):
	pass
	# set_state_label(new_state)

func set_state_label(label: String):
	state_label.set_visible(true)
	state_label.text = "[center]" + label + "[/center]"

## movement ###########################################################

# overwritten in subclass
var speed := 100

# overwritten in subclass
func get_move_dir():
	return Trolls.move_vector()

############################################################
# facing

enum DIR { left, right }
var facing_direction = DIR.left

func face_right():
	facing_direction = DIR.right
	anim.flip_h = true

func face_left():
	facing_direction = DIR.left
	anim.flip_h = false

## action detection ###########################################################

@onready var action_label = $ActionLabel
@onready var action_arrow = $ActionArrow

func update_action_label():
	var ax = action_detector.nearest_action()

	if ax == null:
		action_label.text = ""
		return

	action_label.text = "[center]" + ax.label.capitalize() + "[/center]"

	# fade label if action is not current (i.e. not possible?) bit of naming could help here
	if action_detector.current_action():
		action_label.modulate.a = 1
	elif action_detector.find_nearest(action_detector.potential_actions()):
		action_label.modulate.a = 0.7
	else:
		action_label.modulate.a = 0.4

## items ###########################################################

var item_seed
var item_tool
var item_produce

@onready var produce_icon = $Item/ProduceIcon
@onready var seed_icon = $Item/SeedIcon
@onready var seed_type_icon = $Item/SeedIcon/SeedTypeIcon
@onready var tool_icon = $Item/ToolIcon

func drop_held_item():
	produce_icon.set_visible(false)
	seed_icon.set_visible(false)
	tool_icon.set_visible(false)

	item_seed = null
	item_tool = null
	item_produce = null

func pickup_seed(produce_type):
	drop_held_item()
	seed_icon.set_visible(true)
	seed_type_icon.animation = produce_type
	item_seed = produce_type

func pickup_produce(produce_type):
	drop_held_item()
	produce_icon.set_visible(true)
	produce_icon.animation = produce_type
	item_produce = produce_type

func pickup_tool(tool_type):
	drop_held_item()
	tool_icon.set_visible(true)
	tool_icon.animation = tool_type
	item_tool = tool_type

## seeds ###########################################################

func has_seed():
	if item_seed:
		return true
	else:
		return false

func plant_seed():
	var type = item_seed

	item_seed = null
	drop_held_item()

	return type

## tools, water ###########################################################

func has_tool():
	if item_tool:
		return true
	else:
		return false

func has_water():
	if item_tool == "watering-pail":
		return true
	else:
		return false

func water_plant():
	pass

func action_source_needs_water():
	for src in action_detector.actions.map(func(ax): return ax.source):
		if src.has_method("needs_water"):
			if src.needs_water():
				return true

## produce ############################################################

func harvest_produce(produce_type):
	pickup_produce(produce_type)

func has_produce():
	if item_produce:
		return true
	else:
		return false

signal produce_delivered(item_produce)

func deliver_produce():
	produce_delivered.emit(item_produce)
	drop_held_item()
