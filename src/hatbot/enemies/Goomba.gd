extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var hitbox = $Hitbox

signal died(goomba)
signal knocked_back(goomba)


var death_animation = "dead"
var dying_animation = "dying"
var run_animation = "run"

########################################################
# ready

func _ready():
	machine.start()
	machine.transitioned.connect(_on_transitioned)
	machine.transit("Run")

	Hotel.register(self)

	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)

	died.connect(_on_death)
	knocked_back.connect(_on_knocked_back)

func _on_transitioned(state_label):
	Debug.prn(state_label)
	pass

func _on_death(_goomba):
	Cam.screenshake(0.1)
	# TODO goomba sounds
	DJSounds.play_sound(DJSounds.soldierdead)
	Hotel.check_in(self)

func _on_knocked_back(_goomba):
	if health <= 0:
		anim.play(death_animation)
		# TODO goomba sounds
		DJSounds.play_sound(DJSounds.soldierdead)
	else:
		anim.play(death_animation)
		# TODO goomba sounds
		DJSounds.play_sound(DJSounds.soldierhit)

########################################################
# health/hit

var initial_health = 1
var health

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.RIGHT)

	health -= damage
	Hotel.check_in(self)
	machine.transit("KnockedBack", {direction=direction, dying=health <= 0})

########################################################
# hotel data

func hotel_data():
	var d = {
		name=name,
		position=global_position,
		facing=facing,
		}
	if health != null:
		d["health"] = health
	return d

func check_out(data):
	global_position = data.get("position", global_position)
	health = data.get("health", initial_health)
	facing = data.get("facing", facing)
	face(facing)

	if health <= 0:
		machine.transit("Dead", {ignore_side_effects=true})

########################################################
# facing

func face(face_dir):
	facing = face_dir
	if facing == Vector2.RIGHT:
		face_right()
	elif facing == Vector2.LEFT:
		face_left()

func turn():
	if facing == Vector2.RIGHT:
		face_left()
	elif facing == Vector2.LEFT:
		face_right()
	move_dir = facing

var facing = Vector2.LEFT
func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false


########################################################
# _physics_process

const SPEED = 20.0
const JUMP_VELOCITY = -100.0
const KNOCKBACK_VELOCITY = -100.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 10.0
const DYING_VELOCITY = -200.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_dir = Vector2.ZERO

func _physics_process(_delta):
	pass


########################################################
# hitbox entered

var bodies = []

func _on_body_entered(body):
	Debug.prn("body entered", body)

	if machine.state.name in ["Idle", "Run"] and body.is_in_group("player"):
		bodies.append(body)
		body.take_hit({damage=1, direction=facing})

func _on_body_exited(body):
	bodies.erase(body)
