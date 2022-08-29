extends KinematicBody2D


var velocity = Vector2.ZERO

func _ready():
	velocity = Vector2(-250, 0)

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
