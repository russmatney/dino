tool
extends StaticBody2D

export (String, "carrot", "tomato", "onion") var produce_type = "carrot"

onready var produce_icon = $ProduceIcon
onready var anim = $AnimatedSprite

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

func build_actions(player):
	return [{"obj": self, "method": "pickup_seed", "arg": player}]

func _on_Detectbox_body_entered(body:Node):
	if body.has_method("add_action") and body.has_method("pickup_seed"):
		body.add_action({"obj": self, "method": "pickup_seed", "arg": body})


func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		body.remove_action({"obj": self, "method": "pickup_seed", "arg": body})

##########################################################
# animate

var max_dir_distance = 100
var duration = 0.2
var reset_duration = 0.2

func deform(direction):
	var deformationStrength = clamp(max_dir_distance - direction.length(), 0, max_dir_distance) / max_dir_distance
	var deformationDirection = direction.normalized()
	var deformationScale = 0.5 * deformationDirection * deformationStrength

	var tween = create_tween()
	tween.tween_property(anim.material, "shader_param/deformation",
		deformationScale, duration).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(produce_icon.material, "shader_param/deformation",
		deformationScale, duration).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(anim.material, "shader_param/deformation",
		Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(produce_icon.material, "shader_param/deformation",
		Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

##########################################################
# interactions

func pickup_seed(player):
	player.pickup_seed(produce_type)
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
