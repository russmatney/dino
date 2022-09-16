extends KinematicBody2D

onready var light = $Light2D
export(bool) var light_enabled = false

var velocity = Vector2.ZERO

func _ready():
	velocity = Vector2(-250, 0)
	light.enabled = light_enabled

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
