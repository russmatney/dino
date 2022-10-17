extends Node2D

export(int) var max_speed = 400
export(int) var min_speed = 20
export(int) var x_accel = 400
export(int) var max_air_speed = 300
export(int) var min_air_speed = 100
export(int) var air_resistance = 50
export(int) var gravity = 8000

var jump_velocity = Vector2(100, 400)

var velocity = Vector2.ZERO

onready var body = $KinematicBody2D
onready var anim = $AnimatedSprite

#######################################
# ready

func _ready():
	print("player ready")

#######################################################################33
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		print("player jump action handled!")
		jump()

func jump():
	if body.is_on_floor():
		velocity += jump_velocity

#######################################
# process

func _process(_delta):
	if body.is_on_floor():
		anim.set_animation("run")
	else:
		anim.set_animation("idle") # TODO jumping

#######################################
# physics_process

func _physics_process(delta):
	if body.is_on_floor():
		# run right
		velocity.x += x_accel * delta
		velocity.x = clamp(velocity.x, min_speed, max_speed)
	else:
		# slight slow down
		velocity.x -= air_resistance * delta
		velocity.x = clamp(velocity.x, min_air_speed, max_air_speed)

	# gravity
	velocity.y += gravity * delta

	body.move_and_collide(velocity)
