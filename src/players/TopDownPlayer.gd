extends KinematicBody2D

var move_speed := 800
var max_speed := 200
var velocity := Vector2.ZERO

var initial_pos

func _ready():
	initial_pos = get_global_position()


func _process(delta):
	var move_dir = Trolley.move_dir()
	if move_dir.length() == 0:
		velocity = lerp(velocity, Vector2.ZERO, 0.6)
	else:
		velocity += move_speed * move_dir * delta
		velocity = velocity.limit_length(max_speed)
	velocity = move_and_slide(velocity)
