extends CharacterBody2D

func _ready():
	print("soldier ready")

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var log_every = 1.0
var log_ttl = 1.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	log_ttl -= delta
	if log_ttl <= 0:
		log_ttl = log_every
		print("soldier is logging!")

	move_and_slide()
