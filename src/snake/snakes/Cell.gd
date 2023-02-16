@tool
class_name SnakeCell
extends AnimatedSprite2D

var coord: Vector2

var debugging = false

func _ready():
	if debugging:
		$Coord.text = str(coord)
		$Position.text = str(position)
		$GlobalPosition.text = str(global_position)
	else:
		$Coord.set_visible(false)
		$Position.set_visible(false)
		$GlobalPosition.set_visible(false)


func should_inc_juice():
	# loosey, goosey, eh?
	if animation == "yellow":
		return true


func bounce_in():
	var og_def = material.get_shader_parameter("deformation")
	var def_scale = Vector2.ONE * 2.0
	material.set_shader_param("deformation", def_scale)
	var duration = 0.5
	var reset_duration = 1.0

	var tween = create_tween()
	tween.tween_property(material, "shader_param/deformation", def_scale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(material, "shader_param/deformation", og_def, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)

func deform(def=Vector2(0.9, 0.9)):
	material.set_shader_param("deformation", def)

func bounce(dir):
	animate_deformation(dir)

func animate_deformation(direction):
	var duration = 0.2
	var reset_duration = 0.2
	var def_scale_factor = 0.4

	var og_def = material.get_shader_param("deformation")
	var def_scale = direction * def_scale_factor

	var tween = create_tween()
	tween.tween_property(material, "shader_param/deformation", def_scale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(material, "shader_param/deformation", og_def, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)

func deform_scale(s=Vector2(0.5, 0.5)):
	var duration = 0.1
	var reset_duration = 0.3

	var tween = create_tween()
	tween.tween_property(self, "scale", s, duration).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func shrink(s=Vector2(0.1, 0.1)):
	var duration = 0.3
	var tween = create_tween()
	tween.tween_property(self, "scale", s, duration).set_trans(Tween.TRANS_CUBIC)

func kill():
	var duration = 0.4
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(Callable(self,"queue_free"))
