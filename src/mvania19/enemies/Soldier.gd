extends CharacterBody2D

func _ready():
	print("soldier ready")

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var hit_floor = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if not hit_floor and is_on_floor():
		hit_floor = true
		print(name, " solider hit floor")

	move_and_slide()
