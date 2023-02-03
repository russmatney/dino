tool
extends AnimatedSprite

var coord: Vector2

func _ready():
	$Coord.text = str(coord)
	$Position.text = str(position)
	$GlobalPosition.text = str(global_position)


func bounce(dir, def = 0.9):
	material.set("shader_param/deformation", Vector2(def, def))
	deform(dir)

var max_dir_distance = 5
var duration = 0.2
var reset_duration = 0.2
var def_scale_factor = 0.4

func deform(direction):
	var og_def = material.get("shader_param/deformation")
	var def_scale = direction * def_scale_factor

	var tween = create_tween()
	tween.tween_property(material, "shader_param/deformation", def_scale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(material, "shader_param/deformation", og_def, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)
