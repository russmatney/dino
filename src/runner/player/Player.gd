extends KinematicBody2D

export(int) var max_speed = 200
export(int) var min_speed = 20
export(int) var x_accel = 400
export(int) var stopping_decel = 5
export(int) var max_air_speed = 300
export(int) var min_air_speed = 100
export(int) var air_resistance = 5
export(int) var gravity = 80

var jump_velocity = Vector2(100, -1000)

var velocity = Vector2.ZERO

onready var anim = $AnimatedSprite

#######################################
# ready

var initial_pos: Vector2
func _ready():
	initial_pos = global_position

#######################################################################33
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		jump()

func jump():
	if is_on_floor():
		# we may need a delta-based jump
		velocity += jump_velocity

var stopping = false
func stop_running():
	stopping = true

func start_running():
	stopping = false

#######################################
# process

signal player_resetting

func _process(_delta):
	if is_on_floor() and abs(velocity.x) > 2:
		anim.set_animation("run")
	else:
		anim.set_animation("idle") # TODO jumping

	# quick restart
	if global_position.y > 2000:
		position = initial_pos
		velocity = Vector2.ZERO
		emit_signal("player_resetting")

#######################################
# physics_process

func _physics_process(_delta):
	if stopping:
		velocity.x -= stopping_decel
		if velocity.x < min_speed:
			velocity.x = 0
	elif is_on_floor():
		# run right
		velocity.x += x_accel
		velocity.x = clamp(velocity.x, min_speed, max_speed)
	else:
		# slight slow down
		velocity.x -= air_resistance
		velocity.x = clamp(velocity.x, min_air_speed, max_air_speed)

	# gravity
	velocity.y += gravity

	# move_and_slide factors in delta for us
	velocity = move_and_slide(velocity, Vector2.UP)

#######################################
# pickups

func update_hud():
	print("------------")
	print("player stats: coins: ", coins)

var coins = 0

func add_coin():
	coins += 1
	update_hud()
