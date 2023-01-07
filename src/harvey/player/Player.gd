extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

############################################################
# _input

func _unhandled_input(event):
	if actions and Trolley.is_action(event):
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
# actions

onready var action_label = $ActionLabel
var actions = {}

func update_action_label():
	if not actions:
		action_label.bbcode_text = ""
		return

	if actions:
		var ax = actions.values()[0]
		action_label.bbcode_text = "[center]" + ax["method"].capitalize() + "[/center]"

# TODO refactor towards player registering with current ActionBoxes
# better than requiring movement to add/remove actions
func add_action(ax):
	actions[ax["method"]] = ax
	update_action_label()

func remove_action(ax):
	actions.erase(ax["method"])
	update_action_label()

func perform_action():
	if not actions:
		return

	var ax = actions.values()[0]
	print("performing action: ", ax)
	if "arg" in ax and ax["arg"]:
		ax["obj"].call(ax["method"], ax["arg"])
	else:
		ax["obj"].call(ax["method"])

	# clean up this action after calling
	remove_action(ax)

############################################################
# items

var item_seed
var item_tool
var item_produce

onready var produce_icon = $Item/ProduceIcon
onready var seed_icon = $Item/SeedIcon
onready var tool_icon = $Item/ToolIcon

func drop_held_item():
	# TODO animate, sounds drop held tool/seed

	seed_icon.set_visible(false)
	tool_icon.set_visible(false)
	produce_icon.set_visible(false)

	item_seed = null
	item_tool = null
	item_produce = null

func pickup_seed(produce_type):
	drop_held_item()
	seed_icon.set_visible(true)
	produce_icon.set_visible(true)
	produce_icon.animation = produce_type
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

func plant_seed(plot_inst):
	if has_seed():
		plot_inst.plant_seed(item_seed)
		item_seed = null
		drop_held_item()

############################################################
# water

func has_water():
	if item_tool == "watering-pail":
		return true
	else:
		return false

func water_plant(plot_inst):
	if has_water():
		plot_inst.water_plant()

############################################################
# produce

func harvest_produce(plot_inst):
	pickup_produce(plot_inst.produce_type)
	plot_inst.harvest_produce()

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
