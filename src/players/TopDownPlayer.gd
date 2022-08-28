extends KinematicBody2D

var move_accel := 800
var max_speed := 300
var velocity := Vector2.ZERO

var initial_pos

func _ready():
	initial_pos = get_global_position()


func _process(delta):
	var move_dir = Trolley.move_dir()
	if move_dir.length() == 0:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	else:
		velocity += move_accel * move_dir * delta
		velocity = velocity.limit_length(max_speed)
	velocity = move_and_slide(velocity)
