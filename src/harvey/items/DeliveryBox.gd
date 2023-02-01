tool
extends StaticBody2D

##########################################################
# ready

onready var anim = $AnimatedSprite
onready var action_label = $ActionLabel


func _ready():
	pass


##########################################################
# actions

var actions
var bodies = []


func build_actions(player):
	actions = [{"obj": self, "method": "deliver_produce", "arg": player}]
	set_action_label(player)
	return actions


func can_perform_action(player, action):
	match action["method"]:
		"deliver_produce":
			return bodies.has(player) and could_perform_action(player, action)


func could_perform_action(player, _action):
	return player.has_produce()


func set_action_label(player):
	if not actions:
		return

	# TODO select action better?
	var ax = actions[0]
	action_label.bbcode_text = "[center]" + ax["method"].capitalize() + "[/center]"

	if not can_perform_action(player, ax):
		action_label.modulate.a = 0.5
	else:
		action_label.modulate.a = 1

	action_label.set_visible(true)


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
	tween.tween_property(anim.material, "shader_param/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


##########################################################
# interactions


func deliver_produce(player):
	player.deliver_produce()
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
