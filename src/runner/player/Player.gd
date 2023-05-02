extends CharacterBody2D

var destroy_blocks = false
var activate_blocks = false
var won = false

@export var max_speed: int = 300
@export var min_speed: int = 20
@export var x_accel: int = 50
@export var slowing_decel: int = 5
@export var max_air_speed: int = 200
@export var min_air_speed: int = 50
@export var air_resistance: int = 5
@export var gravity: int = 50

var jump_velocity = Vector2(0, -700)

@onready var anim = $AnimatedSprite2D

@export var fallback_camera: PackedScene = preload("res://addons/camera/Cam2D.tscn")

#######################################
# ready

var restart_pos: Vector2

func _enter_tree():
	Hotel.book(self)

func _ready():
	Hotel.register(self)
	restart_pos = global_position

	Cam.ensure_camera({player=self, zoom_rect_min=100, zoom_rect_max=300})
	Hood.ensure_hud()

func hotel_data():
	return {coins=coins, leaves=leaves}

func check_out(data):
	coins = data.get("coins", coins)
	leaves = data.get("leaves", leaves)

#######################################################################33
# input


func _unhandled_input(event):
	if Trolley.is_action(event):
		jump()


func jump():
	if is_on_floor():
		# we may need a delta-based jump
		velocity += jump_velocity


var slowing = false


func stop_running():
	slowing = true


func start_running():
	slowing = false


#######################################
# process


func _process(_delta):
	if is_on_floor() and abs(velocity.x) > 2:
		anim.set_animation("run")
	else:
		anim.set_animation("idle")  # TODO jump anim

	# quick restart
	if global_position.y > 700:
		restart()


signal player_resetting


func restart():
	# TODO disable/reenable collision detection?
	# or, work checked a timer - first remove_at, then wait a bit, then restart
	position = restart_pos
	velocity = Vector2.ZERO
	stop = false
	player_resetting.emit()


#######################################
# physics_process


func _physics_process(_delta):
	if stop:
		velocity = Vector2.ZERO
	elif slowing:
		velocity.x -= slowing_decel
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
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity


#######################################
# pickups

var coins = 0

func add_coin():
	coins += 1
	Hotel.check_in(self)
	Hood.notif("Grabbed a coin!")

var leaves = []

func caught_leaf(leaf_data):
	leaves.append(leaf_data)
	Hotel.check_in(self)
	Hood.notif("Caught a leaf!")


###########################################
# room api

var current_rooms = []


func entered_room(room):
	current_rooms.append(room)
	var pos = room.restart_position()
	if pos:
		restart_pos = pos


func exited_room(room):
	current_rooms.erase(room)
	if current_rooms.size() == 0 and not won:
		# if we aren't in a room, restart me
		restart()


###########################################
# enemy interactions

var stop = false


func hit(body):
	Debug.pr("player hit by: ", body)
	velocity = Vector2.ZERO
	stop = true
	await get_tree().create_timer(1.0).timeout
	restart()
