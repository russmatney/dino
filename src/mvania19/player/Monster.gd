extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var look_point = $LookPoint
@onready var machine = $Machine

###########################################################################
# ready

func _ready():
	Hood.notif("early notif")
	Cam.ensure_camera(2)
	Hood.ensure_hud()
	machine.start()

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

func face_right():
	anim.flip_h = true
	if look_point.position.x < 0:
		look_point.position.x = -look_point.position.x

func face_left():
	anim.flip_h = false

	if look_point.position.x > 0:
		look_point.position.x = -look_point.position.x
