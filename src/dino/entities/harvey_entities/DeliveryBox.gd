@tool
extends StaticBody2D

##########################################################
# ready

@onready var anim = $AnimatedSprite2D
@onready var action_label = $ActionLabel
@onready var action_area = $ActionArea

var actions = [
	Action.mk({label="Deliver", fn=deliver_produce,
		actor_can_execute=func(player): return player.has_produce(),
		}),
	]

func _ready():
	action_area.action_display_updated.connect(set_action_label)

##########################################################
# actions

func set_action_label():
	var ax = actions[0]
	var is_current = action_area.is_current_for_any_actor(ax)

	action_label.text = "[center]" + ax.label.capitalize() + "[/center]"

	if is_current:
		action_label.modulate.a = 1
	else:
		action_label.modulate.a = 0.5

	action_label.set_visible(true)


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
	tween.tween_property(anim.material, "shader_parameter/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim.material, "shader_parameter/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


##########################################################
# interactions


func deliver_produce(player):
	player.deliver_produce()
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
