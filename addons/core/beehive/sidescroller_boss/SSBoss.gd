@tool
extends CharacterBody2D
class_name SSBoss

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"SSBossMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": [
			"idle", "knocked_back", "dying", "dead",
			"laughing", "stunned", "warp_arrive", "warp_leave",
			# optional/supporting optional attacks:
			# "firing",
			# "preswoop", "swooping",
			]}})

## vars ###########################################################

@export var speed = 200
@export var gravity = 1000
@export var initial_health = 5

@export var can_float = false
@export var can_swoop = false
@export var can_fire = false

var health
var is_dead
var facing
var can_see_player

## signals ###########################################################

signal died(boss)
signal stunned(boss)


## nodes ###########################################################

@onready var machine = $SSBossMachine
@onready var anim = $AnimatedSprite2D
@onready var coll = $CollisionShape2D
@onready var state_label = $StateLabel

var notif_label
var cam_pof
var nav_agent
var skull_particles
var attack_box
var los

var swoop_hint1
var swoop_hint2
var swoop_hint_player
var swoop_hints = []

const warp_group = "warp_spots"
var warp_spots = []

## ready ###########################################################

func _ready():
	Hotel.register(self)

	if not Engine.is_editor_hint():
		U.set_optional_nodes(self, {
			notif_label="NotifLabel",
			cam_pof="CamPOF",
			nav_agent="NavigationAgent2D",
			skull_particles="SkullParticles",
			attack_box="AttackBox",
			los="LineOfSight",
			swoop_hint1="SwoopHint1",
			swoop_hint2="SwoopHint2",
			swoop_hint_player="SwoopHintPlayer",
			})

		if skull_particles:
			skull_particles.set_emitting(false)

		attack_box.body_entered.connect(_on_attack_box_entered)

		swoop_hints = [swoop_hint1, swoop_hint2, swoop_hint_player]\
			.filter(func(x): return x != null)
		for sh in swoop_hints:
			sh.reparent.call_deferred(get_parent())

		machine.transitioned.connect(_on_transit)
		machine.start()

	# look for sibling warp_spots
	warp_spots = U.get_children_in_group(get_parent(), warp_group, false)

	died.connect(_on_death)

	state_label.set_visible(false)

## on transit ####################################################

func _on_transit(label):
	if state_label.visible:
		state_label.text = label

## on death ####################################################

func _on_death(_boss):
	Hotel.check_in(self)
	skull_particles.set_emitting(true)

## hotel ####################################################

func check_out(data):
	global_position = data.get("position", global_position)
	health = data.get("health", initial_health)

	if health <= 0:
		if machine:
			machine.transit("Dead", {ignore_side_effects=true})

func hotel_data():
	return {health=health, position=global_position}


## facing ####################################################

func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false


## physics process ####################################################

func _physics_process(_delta):
	# TODO restore!
	var player
	# player = P.get_player()
	if player and is_instance_valid(player):
		var player_pos = player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			can_see_player = true

			if not is_dead:
				if los.target_position.x > 0:
					face_right()
				else:
					face_left()


## take_hit ####################################################

func take_hit(opts={}):
	if not machine.state.name in ["Stunned", "Swoop", "Firing", "Idle", "Laughing"]:
		DJZ.play(DJZ.S.nodamageclang)
		return

	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.UP)

	DJZ.play(DJZ.S.playerhurt)

	health -= damage
	health = clamp(health, 0, initial_health)
	Hotel.check_in(self)

	if health <= 0:
		is_dead = true

	if not is_dead and machine.state.name in ["Stunned"]:
		machine.transit("Warping")
	else:
		machine.transit("KnockedBack", {
			damage=damage,
			direction=direction,
			})


## player touch damage ####################################################

func _on_attack_box_entered(body: Node):
	if machine.state.name in ["Swoop", "Idle"]:
		if body.is_in_group("player") and body.has_method("take_hit"):
			body.take_hit({body=self})
