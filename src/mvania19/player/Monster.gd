extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine

var player_data

###########################################################################
# ready

var hud = preload("res://src/mvania19/hud/HUD.tscn")

func _ready():
	Cam.ensure_camera(2, {"zoom_level": 5.0})
	Hood.call_deferred("ensure_hud", hud)
	machine.start()
	machine.transitioned.connect(_on_transit)

	if player_data and len(player_data):
		Hood.prn("player_data: ", player_data)
		# TODO merge persisted data

func _on_transit(state):
	Hood.debug_label("Player State: ", state)

	if state in ["Fall", "Run"]:
		stamp_frame()

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
# stamp frame

func stamp_frame():
	var new_anim = AnimatedSprite2D.new()
	new_anim.sprite_frames = anim.sprite_frames
	new_anim.animation = anim.animation
	new_anim.frame = anim.frame

	# definitely more position work to do
	new_anim.global_position = global_position + anim.position
	Navi.add_child_to_current(new_anim)

	var t = create_tween()
	t.tween_property(new_anim, "scale", Vector2(0.3, 0.3), 0.5)
	t.parallel().tween_property(new_anim, "modulate:a", 0.3, 0.5)
	t.tween_callback(new_anim.queue_free)


###########################################################################
# facing

var facing

func update_h_flip(node):
	if facing == "right" and node.position.x < 0:
		node.position.x = -node.position.x
	elif facing == "left" and node.position.x > 0:
		node.position.x = -node.position.x


# @onready var look_point = $LookPoint
func face_right():
	if facing == "left":
		stamp_frame()
	facing = "right"
	anim.flip_h = false
	# update_h_flip(look_point)

func face_left():
	if facing == "right":
		stamp_frame()
	facing = "left"
	anim.flip_h = true
	# update_h_flip(look_point)
