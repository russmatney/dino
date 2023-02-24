@tool
extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine

########################################################
# ready

func _ready():
	Hood.prn("ready")
	if not Engine.is_editor_hint():
		machine.start()
	anim.animation_finished.connect(_on_animation_finished)

	# TODO pull/set data from db when area loads?
	health = initial_health

func _on_animation_finished():
	pass

########################################################
# to_data, restore

func to_data():
	var d = {
		"name": name,
		"position": position,
		}
	if health != null:
		d["health"] = health
	if machine and machine.state and machine.state.name:
		d["state"] = machine.state.name
	return d

func restore(data):
	if "position" in data:
		position = data["position"]
	if "health" in data:
		health = data["health"]
	if "state" in data:
		machine.transit(data["state"], {ignore_side_effects=true})


########################################################
# facing

var facing
func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false

########################################################
# _physics_process

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const KNOCKBACK_VELOCITY = -300.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 30.0
const DYING_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	pass

########################################################
# health

var initial_health = 3
var health

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.RIGHT)

	health -= damage
	machine.transit("KnockedBack", {"direction": direction})
