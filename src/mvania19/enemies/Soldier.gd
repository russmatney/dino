extends CharacterBody2D

func _ready():
	Hood.prn("ready")

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()
