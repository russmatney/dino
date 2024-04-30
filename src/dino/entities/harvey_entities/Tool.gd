@tool
extends CharacterBody2D

@export var tool_type = "watering-pail" # (String, "watering-pail", "shovel")

@onready var tool_icon = $ToolIcon
@onready var action_label = $ActionLabel
@onready var action_area = $ActionArea

var actions = [
	Action.mk({label="Grab Tool", fn=pickup_tool,
		actor_can_execute=could_perform_action,
		})
	]

##########################################################
# ready


func _ready():
	tool_icon.animation = tool_type

	action_area.action_display_updated.connect(set_action_label)


##########################################################
# actions

func could_perform_action(player):
	# players can always grab tools
	if player.is_in_group("player"):
		return true

	# prevent bots from repeatedly picking up tools
	if player.has_tool():
		return false

	# never stop with produce?
	if player.has_produce():
		return false

	# has the bot seen a NeedsWater?
	# hmmmmm this is a bit odd... action cross-deps
	# maybe need action-planning
	match tool_type:
		"watering-pail":
			return player.action_source_needs_water()


func set_action_label():
	action_label.set_visible(true)
	var ax = actions[0]
	var is_current = action_area.is_current_for_any_actor(ax)

	action_label.text = "[center]" + ax.label.capitalize() + "[/center]"

	if is_current:
		action_label.modulate.a = 1
	else:
		action_label.modulate.a = 0.5

##########################################################
# animate

var max_dir_distance = 100
var duration = 0.2
var reset_duration = 0.2


func deform(direction):
	var deformationStrength = (
		clamp(max_dir_distance - direction.length(), 0, max_dir_distance)
		/ max_dir_distance
	)
	var deformationDirection = direction.normalized()
	var deformationScale = 0.5 * deformationDirection * deformationStrength

	var tween = create_tween()
	var anim = tool_icon

	tween.tween_property(anim.material, "shader_parameter/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim.material, "shader_parameter/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


##########################################################
# pickup_tool


func pickup_tool(player):
	player.pickup_tool(tool_type)

	var anim = tool_icon
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
