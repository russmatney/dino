tool
extends KinematicBody2D

onready var anim = $AnimatedSprite

var tween

func _ready():
	if Engine.editor_hint:
		request_ready()

	shader_loop()

func shader_loop():
	tween = get_tree().create_tween()
	tween.set_loops(0)

	tween.tween_property(anim.get_material(), "shader_param/ghost", 1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/red_displacement", 1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/blue_displacement", 1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/green_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_param/ghost", 0.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/red_displacement", -1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/blue_displacement", -1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/green_displacement", -1.0, 1)
