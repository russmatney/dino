class_name HarveyPlayer
extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

############################################################
# ready


func _ready():
	machine.connect("transitioned",Callable(self,"on_transit"))


############################################################
# process


func _process(_delta):
	# probably don't want to call this every frame....
	eval_current_action()

	point_arrow()


func point_arrow():
	var ax = Util._or(c_ax, p_ax, nearest_ax)
	if ax and "source" in ax:
		var rot = get_angle_to(ax["source"].get_global_position()) + (PI / 2)
		action_arrow.set_rotation(rot)


############################################################
# _input


# overwritten in subclass
func _unhandled_input(event):
	if c_ax and Trolley.is_action(event):
		perform_action()


############################################################
# machine

@onready var machine = $Machine
@onready var state_label = $StateLabel


func on_transit(new_state):
	if Harvey.debug_mode():
		set_state_label(new_state)


func set_state_label(label: String):
	state_label.set_visible(true)
	state_label.text = "[center]" + label + "[/center]"


############################################################
# movement

# overwritten in subclass
var speed := 100


# overwritten in subclass
func get_move_dir():
	return Trolley.move_dir()


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
# TODO move to ActionDetector script

@onready var action_label = $ActionLabel
@onready var action_arrow = $ActionArrow
var actions = []
var c_ax  # current action
var p_ax  # nearest potential action
var nearest_ax  # current action


func action_sources(axs = actions):
	var srcs = {}
	for ax in axs:
		if "source_name" in ax:
			srcs[ax["source_name"]] = ax["source"]
	return srcs.values()


func update_action_label():
	var ax = Util._or(c_ax, p_ax, nearest_ax)

	if ax == null:
		action_label.text = ""
		return

	action_label.text = "[center]" + ax["method"].capitalize() + "[/center]"

	# fade label if action is not current (i.e. not possible?) bit of naming could help here
	if c_ax:
		action_label.modulate.a = 1
	elif p_ax:
		action_label.modulate.a = 0.7
	else:
		action_label.modulate.a = 0.4


func update_action_arrow():
	if actions.size() == 0:
		action_arrow.set_visible(false)
		return
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


func immediate_actions():
	# TODO refactor into a filter predicate style
	var axs = []
	for ax in actions:
		if "source" in ax and ax["source"].has_method("can_perform_action"):
			if ax["source"].can_perform_action(self, ax):
				axs.append(ax)
	return axs


# TODO refactor to call can/could separately (and find better naming)
func potential_actions():
	# TODO refactor into a filter predicate style
	var axs = []
	for ax in actions:
		if "source" in ax and ax["source"].has_method("could_perform_action"):
			if ax["source"].could_perform_action(self, ax):
				axs.append(ax)
	return axs


func eval_current_action():
	c_ax = null
	p_ax = null
	nearest_ax = null

	if actions:
		var im_axs = immediate_actions()
		var pot_axs = []
		if im_axs.size() == 0:
			pot_axs = potential_actions()

		if im_axs.size() > 0:
			var nearest_action = find_nearest_action(im_axs)
			c_ax = nearest_action
		if pot_axs.size() > 0:
			p_ax = find_nearest_action(pot_axs)
	else:
		c_ax = null
		p_ax = null
		nearest_ax = null

	nearest_ax = find_nearest_action()
	update_action_label()
	update_action_arrow()


func _on_ActionDetector_area_entered(area: Area2D):
	if area.name == "Detectbox":
		if area.get_parent().has_method("build_actions"):
			for ax in area.get_parent().build_actions(self):
				ax.merge(
					{
						"source_name": area.get_parent().name,
						"source": area.get_parent(),
					}
				)
				add_action(ax)


func _on_ActionDetector_area_exited(area: Area2D):
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


func has_action(method):
	for ax in actions:
		if ax["method"] == method:
			return true
	return false


############################################################
# performing actions


func perform_action():
	if c_ax == null:
		return

	var ax = c_ax
	print("\n\nperforming action: ", ax["method"])
	if "arg" in ax and ax["arg"]:
		ax["obj"].call(ax["method"], ax["arg"])
	else:
		ax["obj"].call(ax["method"])

	eval_current_action()

	print("next action:")

	print("has_seed: ", has_seed())
	print("has_tool: ", has_water())
	print("has_produce: ", has_produce())
	if c_ax:
		print("c_ax: ", c_ax["method"])
	if p_ax:
		print("p_ax: ", p_ax["method"])
	if nearest_ax:
		print("nearest_ax: ", nearest_ax["method"])


############################################################
# items

var item_seed
var item_tool
var item_produce

@onready var produce_icon = $Item/ProduceIcon
@onready var seed_icon = $Item/SeedIcon
@onready var seed_type_icon = $Item/SeedIcon/SeedTypeIcon
@onready var tool_icon = $Item/ToolIcon


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
# tools, water


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
	for src in action_sources():
		if src.has_method("needs_water"):
			if src.needs_water():
				return true


############################################################
# produce


func harvest_produce(produce_type):
	pickup_produce(produce_type)


func has_produce():
	if item_produce:
		return true
	else:
		return false


func deliver_produce():
	# TODO only for player, not for bots
	Harvey.produce_delivered(item_produce)
	drop_held_item()
