@tool
extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var tween
var coll_enabled = true
@export var alpha_threshold: float = 0.2
@export var offset: float = 0.5


func enable_collision():
	coll_enabled = true
	$CollisionShape2D.set_deferred("disabled", false)
	$Label.text = "enabled"


func disable_collision():
	coll_enabled = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Label.text = "disabled"


func _ready():
	if Engine.is_editor_hint():
		request_ready()

	shader_loop()


func shader_loop():
	tween = create_tween()
	tween.set_loops(0)
	tween.tween_property(anim.get_material(), "shader_parameter/alpha", 0.95, 3 + offset)
	tween.tween_property(anim.get_material(), "shader_parameter/alpha", 0.0, 1 + offset)


func _process(_delta):
	var alpha = anim.get_material().get_shader_parameter("alpha")
	if alpha:
		if coll_enabled and alpha < alpha_threshold:
			disable_collision()
		elif not coll_enabled and alpha > alpha_threshold:
			enable_collision()
