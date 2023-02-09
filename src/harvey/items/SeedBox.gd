@tool
extends StaticBody2D

@export var produce_type = "carrot" # (String, "carrot", "tomato", "onion")

@onready var produce_icon = $ProduceIcon
@onready var anim = $AnimatedSprite2D
@onready var action_label = $ActionLabel

##########################################################
# ready


func _ready():
	produce_icon.animation = produce_type


##########################################################
# input


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var direction = anim.global_position - get_global_mouse_position()
		deform(direction)


##########################################################
# detectbox

var actions
var bodies = []


func build_actions(player):
	actions = [{"obj": self, "method": "pickup_seed", "arg": player}]
	set_action_label(player)
	return actions


func can_perform_action(player, action):
	match action["method"]:
		"pickup_seed":
			return bodies.has(player) and could_perform_action(player, action)


func could_perform_action(player, _action):
	# players can always grab seeds
	if player.is_in_group("player"):
		return true

	# never stop with produce?
	if player.has_produce():
		return false

	# bot can't pick up another seed
	return not player.has_seed()


func set_action_label(player):
	action_label.set_visible(true)

	# TODO select action better?
	var ax = actions[0]
	action_label.text = "[center]" + ax["method"].capitalize() + "[/center]"

	if not can_perform_action(player, ax):
		action_label.modulate.a = 0.5
	else:
		action_label.modulate.a = 1


# TODO detecting bodies instead of areas, should probably switch to actual ActionDetectors areas
# otherwise it gets conflated with the node supporting it (the body)
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
	tween.tween_property(anim.material, "shader_param/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.parallel().tween_property(produce_icon.material, "shader_param/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim.material, "shader_param/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)
	tween.parallel().tween_property(produce_icon.material, "shader_param/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


##########################################################
# interactions


func pickup_seed(player):
	player.pickup_seed(produce_type)
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
