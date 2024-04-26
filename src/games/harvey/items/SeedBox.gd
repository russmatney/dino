@tool
extends StaticBody2D

@export var produce_type = "carrot" # (String, "carrot", "tomato", "onion")

@onready var produce_icon = $ProduceIcon
@onready var anim = $AnimatedSprite2D
@onready var action_label = $ActionLabel
@onready var action_area = $ActionArea

##########################################################
# ready

var actions = [
	Action.mk({label="Get Seed", fn=pickup_seed,
		actor_can_execute=could_perform_action}),
	]

func _ready():
	produce_icon.animation = produce_type

	action_area.action_display_updated.connect(set_action_label)


##########################################################
# input


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var direction = anim.global_position - get_global_mouse_position()
		deform(direction)


##########################################################
# detectbox

func could_perform_action(player):
	# players can always grab seeds
	if player.is_in_group("player"):
		return true

	# never stop with produce?
	if player.has_produce():
		return false

	# bot can't pick up another seed
	return not player.has_seed()


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
	tween.tween_property(anim.material, "shader_parameter/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.parallel().tween_property(produce_icon.material, "shader_parameter/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim.material, "shader_parameter/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)
	tween.parallel().tween_property(produce_icon.material, "shader_parameter/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


##########################################################
# interactions


func pickup_seed(player):
	player.pickup_seed(produce_type)
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
