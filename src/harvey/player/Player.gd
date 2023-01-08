extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

############################################################
# process

func _process(_delta):
	# probably don't want to call this every frame....
	eval_current_action()

	var ax = Util._or(c_ax, nearest_ax)
	if ax and "source" in ax:
		var rot = get_angle_to(ax["source"].get_global_position()) + (PI/2)
		action_arrow.set_rotation(rot)

############################################################
# _input

func _unhandled_input(event):
	if c_ax and Trolley.is_action(event):
		perform_action()

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

############################################################
# movement

var velocity = Vector2.ZERO
var speed := 100

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

############################################################
# action detection

onready var action_label = $ActionLabel
onready var action_arrow = $ActionArrow
var actions = []
var c_ax # current action
var nearest_ax # current action

func action_sources(axs = actions):
	var srcs = {}
	for ax in axs:
		if "source_name" in ax:
			srcs[ax["source_name"]] = ax["source"]
	return srcs.values()

func update_action_label():
	if not c_ax:
		action_label.bbcode_text = ""
		return

	action_label.bbcode_text = "[center]" + c_ax["method"].capitalize() + "[/center]"

func update_action_arrow():
	if not actions:
		action_arrow.set_visible(false)
		return

	# note, not always a possible action
	nearest_ax = find_nearest_action()
	action_arrow.set_visible(true)

func find_nearest_action(axs = actions):
	if axs.size() == 1:
		return axs[0]
	var srcs = action_sources(axs)
	var nearest_src = Util.nearest_node(self, srcs)
	var nearest_action
	for ax in actions:
		if "source" in ax and ax["source"] == nearest_src:
			nearest_action = ax
			break
	return nearest_action

func eval_current_action():
	if actions:
		var possible_actions = []
		for ax in actions:
			if "source" in ax and ax["source"].has_method("can_perform_action"):
				if ax["source"].can_perform_action(self, ax):
					possible_actions.append(ax)

		var nearest_action = find_nearest_action(possible_actions)
		c_ax = nearest_action
	else:
		c_ax = null

	update_action_label()
	update_action_arrow()

func _on_ActionDetector_area_entered(area:Area2D):
	if area.name == "Detectbox":
		if area.get_parent().has_method("build_actions"):
			for ax in area.get_parent().build_actions(self):
				ax.merge({
					"source_name": area.get_parent().name,
					"source": area.get_parent(),
					})
				add_action(ax)

func _on_ActionDetector_area_exited(area:Area2D):
	if area.name == "Detectbox":
		remove_actions_with_source(area.get_parent().name)

func add_action(ax):
	actions.append(ax)
	eval_current_action()

func remove_action(ax):
	actions.erase(ax)
	eval_current_action()

func remove_actions_with_source(name):
	# this should be simpler - if not, create a util/extension for Array.filter()
	var to_remove = []
	for ax in actions:
		if "source_name" in ax and ax["source_name"] == name:
			to_remove.append(ax)
	for ax in to_remove:
		actions.erase(ax)
	eval_current_action()

############################################################
# performing actions

func perform_action():
	if not c_ax:
		return

	var ax = c_ax
	print("performing action: ", ax["method"])
	if "arg" in ax and ax["arg"]:
		ax["obj"].call(ax["method"], ax["arg"])
	else:
		ax["obj"].call(ax["method"])

	eval_current_action()

############################################################
# items

var item_seed
var item_tool
var item_produce

onready var produce_icon = $Item/ProduceIcon
onready var seed_icon = $Item/SeedIcon
onready var seed_type_icon = $Item/SeedIcon/SeedTypeIcon
onready var tool_icon = $Item/ToolIcon

func drop_held_item():
	# TODO animation, sounds

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

############################################################
# seeds

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

############################################################
# water

func has_water():
	if item_tool == "watering-pail":
		return true
	else:
		return false

func water_plant():
	pass

############################################################
# produce

func harvest_produce(produce_type):
	pickup_produce(produce_type)

func has_produce():
	if item_produce:
		return true
	else:
		return false

var produce_delivered = 0

func deliver_produce():
	produce_delivered = produce_delivered + 1
	print("player delivering produce: ", item_produce, " total: ", produce_delivered)
	drop_held_item()
