tool
extends KinematicBody2D

export(String, "watering-pail", "shovel") var tool_type = "watering-pail"

onready var tool_icon = $ToolIcon
onready var action_label = $ActionLabel

##########################################################
# ready


func _ready():
	tool_icon.animation = tool_type


##########################################################
# detectbox

var actions
var bodies = []


func build_actions(player):
	actions = [{"obj": self, "method": "pickup_tool", "arg": player}]
	set_action_label(player)
	return actions


func can_perform_action(player, action):
	match action["method"]:
		"pickup_tool":
			return bodies.has(player) and could_perform_action(player, action)


func could_perform_action(player, _action):
	# players can always grab tools
	if player.is_in_group("player"):
		return true

	# prevent bots from repeatedly picking up tools
	if player.has_tool():
		return false

	# never stop with produce?
	if player.has_produce():
		return false

	# TODO has the bot seen a NeedsWater?
	# connected actions?
	# some spaghetti pattern starting?
	match tool_type:
		"watering-pail":
			return player.action_source_needs_water()


func set_action_label(player):
	action_label.set_visible(true)

	# TODO select action better?
	var ax = actions[0]
	action_label.bbcode_text = "[center]" + ax["method"].capitalize() + "[/center]"

	if not can_perform_action(player, ax):
		action_label.modulate.a = 0.5
	else:
		action_label.modulate.a = 1


func _on_Detectbox_body_entered(body: Node):
	if body.is_in_group("action_detector"):
		bodies.append(body)
		set_action_label(body)


func _on_Detectbox_body_exited(body: Node):
	if body.is_in_group("action_detector"):
		bodies.erase(body)
		set_action_label(body)


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

	tween.tween_property(anim.material, "shader_param/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim.material, "shader_param/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


##########################################################
# pickup_tool


func pickup_tool(player):
	player.pickup_tool(tool_type)

	var anim = tool_icon
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
