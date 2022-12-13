extends KinematicBody2D

var dead = false

#######################################################################33
# physics process

var dir = Vector2.RIGHT
export(int) var speed = 100
export(int) var gravity := 4000
var velocity = dir * speed

func _physics_process(delta):
	velocity.y += gravity * delta

	if not dead:
		velocity.x = dir.x * max(speed, velocity.x)
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_wall():
			match dir:
				Vector2.LEFT: dir = Vector2.RIGHT
				Vector2.RIGHT: dir = Vector2.LEFT
