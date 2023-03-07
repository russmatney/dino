@tool
extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var hitbox = $Hitbox

########################################################
# ready

func _ready():
	if not Engine.is_editor_hint():
		machine.start()
		machine.transitioned.connect(_on_transitioned)
		machine.transit("Run", {dir=Vector2.LEFT})

	restore()
	Hotel.check_in(self)

	anim.animation_finished.connect(_on_animation_finished)

	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)

	anim.frame_changed.connect(_on_frame_changed)

func _on_frame_changed():
	if anim.animation == "kick" and anim.frame in [3, 4, 5, 6]:
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

var bodies = []

func _on_body_entered(body):
	Debug.prn("body entered", body)

	if body.is_in_group("player"):
		bodies.append(body)

		if machine.state.name != "Kick":
			kick(body)

func _on_body_exited(body):
	bodies.erase(body)

func _on_transitioned(state_label):
	Debug.prn(state_label)

func _on_animation_finished():
	if anim.animation == "kick":
		machine.transit("Idle")

########################################################
# hotel data

func hotel_data():
	var d = {
		"name": name,
		"position": global_position,
		}
	if health != null:
		d["health"] = health
	return d

func restore():
	var data = Hotel.check_out(self)
	if not data == null:
		global_position = data.get("position", global_position)
		health = data.get("health", initial_health)

		if health <= 0:
			machine.transit("Dead", {ignore_side_effects=true})


########################################################
# facing

var facing
func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true
	Util.update_h_flip(facing, hitbox)

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false
	Util.update_h_flip(facing, hitbox)

########################################################
# _physics_process

const SPEED = 50.0
const JUMP_VELOCITY = -300.0
const KNOCKBACK_VELOCITY = -300.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 30.0
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
	machine.transit("KnockedBack", {"direction": direction})
