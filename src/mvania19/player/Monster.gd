extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var sword = $Sword
@onready var action_hint = $ActionHint
@onready var action_detector = $ActionDetector

var player_data

var og_position
var MAX_Y = 5000

###########################################################################
# ready

var hud = preload("res://src/mvania19/hud/HUD.tscn")

func _ready():
	og_position = position
	Cam.ensure_camera(2, {"zoom_level": 5.0})
	Hood.call_deferred("ensure_hud", hud)
	machine.start()
	machine.transitioned.connect(_on_transit)

	if player_data and len(player_data):
		Debug.prn("player_data: ", player_data)
		# TODO merge persisted data

	action_detector.setup(self, can_execute_any_actions, action_hint)

	sword.bodies_updated.connect(_on_sword_bodies_updated)

	health = initial_health


func can_execute_any_actions():
	return move_target == null

func _on_transit(state):
	Debug.debug_label("Player State: ", state)
	Debug.debug_label("Player pos: ", global_position)

	if state in ["Fall", "Run"]:
		stamp()

func _on_sword_bodies_updated(bodies):
	if len(bodies) > 0:
		# TODO hide when we've seen some amount of sword action
		# i.e. the player has learned it
		# TODO combine with 'forget learned actions' pause button
		action_hint.display("attack", "Sword")
	else:
		action_hint.hide()

###########################################################################
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		stamp({"scale": 2.0, "ttl": 1.0})
		var _executed = action_detector.execute_current_action()
		# TODO fire stamp via actions api? use whatever the current action_hint is?
		Cam.hitstop("player_hitstop", 0.5, 0.2)
	elif Trolley.is_attack(event):
		sword.swing()
		stamp({"scale": 2.0, "ttl": 1.0})

###########################################################################
# movement

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const KNOCKBACK_VELOCITY = -300.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 30.0
const DYING_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_dir = Vector2.ZERO
var move_target

func get_move_dir():
	if move_target != null:
		var towards_target = move_target - position
		var dist = towards_target.length()
		if dist >= 5:
			return towards_target.normalized()
		else:
			return Vector2.ZERO
		# note, no movement can occur until move_target is unset
	else:
		return Trolley.move_dir()

func _physics_process(_delta):
	# assign move_dir
	move_dir = get_move_dir()
	Debug.debug_label("move_dir: ", move_dir)

	if move_dir:
		# update facing
		if move_dir.x > 0:
			face_right()
		if move_dir.x < 0:
			face_left()

	if position.y > MAX_Y:
		Debug.warn("MAX Y HIT - RESETTING PLAYER")
		velocity = Vector2.ZERO
		position = og_position

func move_to_target(target_position):
	move_target = target_position

func clear_move_target():
	move_target = null


###########################################################################
# stamp frame

func stamp(opts={}):
	if not Engine.is_editor_hint() and move_target == null:
		var new_scale = opts.get("scale", 0.3)
		var ttl = opts.get("ttl", 0.5)
		var new_anim = AnimatedSprite2D.new()
		new_anim.sprite_frames = anim.sprite_frames
		new_anim.animation = anim.animation
		new_anim.frame = anim.frame

		var ax_hint = action_hint.duplicate()
		new_anim.add_child(ax_hint)

		# definitely more position work to do...?
		new_anim.global_position = global_position + anim.position
		Navi.add_child_to_current(new_anim)

		var t = create_tween()
		t.tween_property(new_anim, "scale", Vector2(new_scale, new_scale), ttl)
		t.parallel().tween_property(new_anim, "modulate:a", 0.3, ttl)
		t.tween_callback(new_anim.queue_free)


###########################################################################
# facing

var facing

@onready var light_occluder = $LightOccluder2D
@onready var look_point = $LookPoint

func face_right():
	if facing == Vector2.LEFT:
		stamp()
	facing = Vector2.RIGHT
	anim.flip_h = false
	Util.update_h_flip(facing, sword)
	Util.update_h_flip(facing, light_occluder)
	Util.update_h_flip(facing, look_point)

func face_left():
	if facing == Vector2.RIGHT:
		stamp()
	facing = Vector2.LEFT
	anim.flip_h = true
	Util.update_h_flip(facing, sword)
	Util.update_h_flip(facing, light_occluder)
	Util.update_h_flip(facing, look_point)

########################################################
# health

var initial_health = 3
var health

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.RIGHT)

	health -= damage
	machine.transit("KnockedBack", {"direction": direction})
