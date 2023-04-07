@tool
extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var hitbox = $Hitbox
@onready var front_ray = $FrontRay
@onready var low_los = $LowLineOfSight
@onready var high_los = $HighLineOfSight

signal died(soldier)
signal knocked_back(soldier)

var death_animation = "dead"
var dying_animation = "dying"
var run_animation = "run"

########################################################
# ready

var line_of_sights = []

func _ready():
	if not Engine.is_editor_hint():
		machine.start()
		machine.transitioned.connect(_on_transitioned)
		machine.transit("Run")

	Hotel.register(self)

	line_of_sights = [low_los, high_los]

	anim.animation_finished.connect(_on_animation_finished)
	anim.frame_changed.connect(_on_frame_changed)

	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)

	died.connect(_on_death)
	knocked_back.connect(_on_knocked_back)

func _on_transitioned(_state_label):
	pass
	# Debug.prn(state_label)

func _on_death(_soldier):
	Cam.screenshake(0.3)
	DJSounds.play_sound(DJSounds.soldierdead)
	Hotel.check_in(self)

func _on_knocked_back(_soldier):
	if health <= 0:
		anim.play("dying")
		DJSounds.play_sound(DJSounds.soldierdead)
	else:
		anim.play("knockback")
		DJSounds.play_sound(DJSounds.soldierhit)

########################################################
# kick

# should move this to the machine's kick state

func _on_animation_finished():
	if anim.animation == "kick":
		machine.transit("Idle")

func _on_frame_changed():
	if anim.animation == "idle":
		if anim.frame in [3, 4, 5, 6]:
			for los in line_of_sights:
				Util.update_los_facing(-1*facing, los)
		else:
			for los in line_of_sights:
				Util.update_los_facing(facing, los)

	elif anim.animation == "kick" and anim.frame in [3, 4, 5, 6]:
		for b in bodies:
			if b.has_method("take_hit"):
				if not b in bodies_this_kick:
					Cam.hitstop("kickhit", 0.3, 0.1)
					bodies_this_kick.append(b)
					b.take_hit({damage=1, direction=facing})

var bodies_this_kick = []

func kick(body):
	bodies_this_kick = []
	machine.transit("Kick", {body=body})

########################################################
# kick collisions

var bodies = []

func _on_body_entered(body):
	Debug.prn("body entered", body)

	if body.is_in_group("player"):
		bodies.append(body)

		# should probably do this from the state's physics_process()
		if machine.state.name in ["Idle", "Run"]:
			kick(body)

func _on_body_exited(body):
	bodies.erase(body)


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

	if health <= 0:
		machine.transit("Dead", {ignore_side_effects=true})


########################################################
# facing

func turn():
	if facing == Vector2.RIGHT:
		face_left()
	elif facing == Vector2.LEFT:
		face_right()
	move_dir.x = -1 * move_dir.x

var facing = Vector2.LEFT
func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true
	Util.update_h_flip(facing, hitbox)
	Util.update_h_flip(facing, front_ray)
	for los in line_of_sights:
		Util.update_los_facing(facing, los)

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false
	Util.update_h_flip(facing, hitbox)
	Util.update_h_flip(facing, front_ray)
	for los in line_of_sights:
		Util.update_los_facing(facing, los)

########################################################
# _physics_process

const SPEED = 50.0
const JUMP_VELOCITY = -300.0
const KNOCKBACK_VELOCITY = -300.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 20.0
const DYING_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_dir = Vector2.ZERO

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
	Hotel.check_in(self)
	machine.transit("KnockedBack", {direction=direction, dying=health <= 0})
