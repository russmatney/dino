extends CharacterBody2D

@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D
@onready var los = $LineOfSight
@onready var attack_box = $AttackBox

@onready var swoop_hint1 = $SwoopHint1
@onready var swoop_hint2 = $SwoopHint2
@onready var swoop_hint_player = $SwoopHintPlayer
var swoop_hints = []

@onready var skull_particles = $SkullParticles

const warp_group = "warp_spots"
var warp_spots = []

const can_float = true
const can_swoop = true

#####################################################
# ready

func _ready():
	if not Engine.is_editor_hint():
		machine.start()
		machine.transitioned.connect(_on_transit)

	Hotel.register(self)

	warp_spots = Util.get_children_in_group(get_parent(), warp_group, false)

	died.connect(_on_death)

	attack_box.body_entered.connect(_on_attack_box_entered)

	swoop_hints = [swoop_hint1, swoop_hint2, swoop_hint_player]
	for sh in swoop_hints:
		sh.call_deferred("reparent", get_parent())


func _on_death(_boss):
	Hotel.check_in(self)
	skull_particles.set_emitting(true)

func _on_transit(state_label):
	Debug.pr(state_label)
	# Debug.debug_label(name, "state", state_label)

#####################################################
# hotel

func check_out(data):
	global_position = data.get("position", global_position)
	health = data.get("health", initial_health)

	if health <= 0:
		if machine:
			machine.transit("Dead", {ignore_side_effects=true})

func hotel_data():
	return {health=health, position=global_position}

#####################################################
# facing

var facing

func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false

#####################################################
# movement

const SPEED = 200
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

#####################################################
# shared process

var can_see_player

func _physics_process(_delta):
	if MvaniaGame.player:
		var player_pos = MvaniaGame.player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			can_see_player = true

			if los.target_position.x > 0:
				face_right()
			else:
				face_left()

#####################################################
# attack

signal fired_bullet(bullet)

#####################################################
# take_hit

var initial_health = 5
var health
var dead

signal died(boss)
signal stunned(boss)

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.UP)

	DJSounds.play_sound(DJSounds.playerhurt)

	health -= damage
	health = clamp(health, 0, initial_health)
	Hotel.check_in(self)

	if health <= 0:
		dead = true

	machine.transit("KnockedBack", {
		damage=damage,
		direction=direction,
		})

#####################################################
# touch damage

func _on_attack_box_entered(body: Node):
	if machine.state.name in ["Swoop", "Idle"]:
		if body.is_in_group("player") and body.has_method("take_hit"):
			var dir
			if global_position.x > body.global_position.x:
				dir = Vector2.LEFT
			else:
				dir = Vector2.RIGHT
			body.take_hit({"direction": dir})
