tool
extends AnimatedSprite

var coord: Vector2


func _ready():
	pass


func bounce(dir):
	material.set("shader_param/deformation", Vector2(0.9, 0.9))
	deform(dir)

var max_dir_distance = 50
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
	tween.tween_property(material, "shader_param/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(material, "shader_param/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)
