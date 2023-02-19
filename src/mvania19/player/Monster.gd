extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var look_point = $LookPoint
@onready var machine = $Machine

var player_data

###########################################################################
# ready

var hud = preload("res://src/mvania19/hud/HUD.tscn")

func _ready():
	Cam.ensure_camera(2, 30000, 7)
	Hood.call_deferred("ensure_hud", hud)
	machine.start()

	if player_data and len(player_data):
		print("player_data: ", player_data)
		# TODO merge

###########################################################################
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		if len(actions) > 0:
			var ax = actions[0]
			ax["fn"].call()

###########################################################################
# actions

var actions = []
func add_action(ax):
	actions.append(ax)
func remove_action(ax):
	actions.erase(ax)

###########################################################################
# movement

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_dir = Vector2.ZERO

func _physics_process(_delta):
	# assign move_dir
	move_dir = Trolley.move_dir()

	# update facing
	if move_dir.x > 0:
		face_right()
	if move_dir.x < 0:
		face_left()


###########################################################################
# facing

var facing

func update_h_flip(node):
	if facing == "right" and node.position.x < 0:
		node.position.x = -node.position.x
	elif facing == "left" and node.position.x > 0:
		node.position.x = -node.position.x

func face_right():
	facing = "right"
	anim.flip_h = false
	update_h_flip(look_point)

func face_left():
	facing = "left"
	anim.flip_h = true
	update_h_flip(look_point)
