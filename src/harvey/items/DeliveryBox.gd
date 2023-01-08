tool
extends StaticBody2D

##########################################################
# ready

onready var anim = $AnimatedSprite

func _ready():
	pass

##########################################################
# actions

func _on_Detectbox_body_entered(body:Node):
	if body.has_method("add_action"):
		if body.has_method("has_produce") and body.has_produce() and body.has_method("deliver_produce"):
			body.add_action({"obj": self, "method": "deliver_produce", "arg": body})

func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		body.remove_action({"obj": self, "method": "deliver_produce", "arg": body})

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
	tween.tween_property(anim.material, "shader_param/deformation",
		Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

##########################################################
# interactions

func deliver_produce(player):
	player.deliver_produce()
	var dir = anim.global_position - player.get_global_position()
	deform(dir)
