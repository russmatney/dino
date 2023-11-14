@tool
extends CharacterBody2D
class_name SSEnemy

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"SSEnemyMachine", "StateLabel", "AnimatedSprite2D", "Hitbox"
		], expected_animations={"AnimatedSprite2D": [
			"idle", "run", "knocked_back", "dying", "dead",
			# "laughing", "kick"
			]}})

## vars ###########################################################

@export var speed = 20.0
@export var gravity = 1000
@export var jump_velocity = -100.0
@export var knockback_velocity = -100.0
@export var knockback_velocity_horizontal = 10.0
@export var dying_velocity = -200.0

@export var initial_health = 1

@export var should_crawl_on_walls = false
@export var should_see_player = false
@export var can_kick = false
@export var should_hurt_to_touch = false


var health
var is_dead
var can_see_player
var facing_vector = Vector2.RIGHT
var move_vector

var crawl_on_side

## signals ###########################################################

signal died(enemy)
signal stunned(enemy)
signal knocked_back(enemy)

## nodes ###########################################################

@onready var anim = $AnimatedSprite2D
@onready var machine = $SSEnemyMachine
@onready var coll = $CollisionShape2D
@onready var state_label = $StateLabel
@onready var hitbox = $Hitbox

var notif_label
var cam_pof
var nav_agent
var skull_particles
var attack_box
var los
var front_ray
var low_los
var high_los

var line_of_sights = []

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		U.set_optional_nodes(self, {
			notif_label="NotifLabel",
			cam_pof="CamPOF",
			nav_agent="NavigationAgent2D",
			skull_particles="SkullParticles",
			los="LineOfSight",
			front_ray="FrontRay",
			low_los="LowLineOfSight",
			high_los="HighLineOfSight",
			})

		if skull_particles:
			skull_particles.set_emitting(false)

		if low_los and high_los:
			line_of_sights = [low_los, high_los]

		machine.transitioned.connect(_on_transit)
		machine.start()

	Hotel.register(self)

	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)

	anim.animation_finished.connect(_on_animation_finished)
	anim.frame_changed.connect(_on_frame_changed)

	died.connect(_on_death)
	knocked_back.connect(_on_knocked_back)

	state_label.set_visible(false)

## physics process ####################################################

func _physics_process(_delta):
	if crawl_on_side == null and should_crawl_on_walls:
		if is_on_wall_only():
			crawl_on_side = get_wall_normal()
		elif is_on_floor_only():
			crawl_on_side = Vector2.DOWN
		elif is_on_ceiling_only():
			crawl_on_side = Vector2.UP
		if crawl_on_side != null:
			orient_to_wall(crawl_on_side)

	var player = P.get_player()
	if player and is_instance_valid(player) and should_see_player and los:
		# var player_pos = player.global_position
		# los.target_position = to_local(player_pos)

		if los.is_colliding():
			var body = los.get_collider()
			if body.is_in_group("player"):
				can_see_player = true
			else:
				can_see_player = false

## on transit ####################################################

func _on_transit(label):
	if state_label.visible:
		state_label.text = label

## on death ####################################################

func _on_death(_enemy):
	Hotel.check_in(self)
	Cam.screenshake(0.1)
	DJZ.play(DJZ.S.soldierdead)
	if skull_particles:
		skull_particles.set_emitting(true)


## on knockback ####################################################

func _on_knocked_back(_goomba):
	if health <= 0:
		anim.play("dead")
		DJZ.play(DJZ.S.soldierdead)
	else:
		anim.play("dead")
		DJZ.play(DJZ.S.soldierhit)

## hotel ####################################################

func check_out(data):
	var pos = data.get("position", global_position)
	if pos != null and pos != Vector2.ZERO:
		global_position = pos
	health = data.get("health", initial_health)
	facing_vector = data.get("facing_vector", facing_vector)
	face(facing_vector)

	crawl_on_side = data.get("crawl_on_side", crawl_on_side)
	if crawl_on_side:
		orient_to_wall(crawl_on_side)

	if health <= 0:
		if machine and machine.is_started:
			machine.transit("Dead", {ignore_side_effects=true})

func hotel_data():
	return {name=name, health=health,
		position=global_position,
		facing_vector=facing_vector,
		crawl_on_side=crawl_on_side,
		}


## facing ####################################################

func face(face_dir):
	facing_vector = face_dir
	if facing_vector == Vector2.RIGHT:
		face_right()
	elif facing_vector == Vector2.LEFT:
		face_left()

func turn():
	if facing_vector == Vector2.RIGHT:
		face_left()
	elif facing_vector == Vector2.LEFT:
		face_right()
	move_vector = facing_vector

func face_right():
	facing_vector = Vector2.RIGHT
	anim.flip_h = true
	update_facing()

func face_left():
	facing_vector = Vector2.LEFT
	anim.flip_h = false
	update_facing()

func update_facing():
	U.update_h_flip(facing_vector, hitbox)
	U.update_h_flip(facing_vector, front_ray)
	for los in line_of_sights:
		U.update_los_facing(facing_vector, los)

## wall crawlers #######################################################

func orient_to_wall(side):
	match(side):
		Vector2.UP:
			rotation_degrees = 180.0
		Vector2.DOWN:
			rotation_degrees = 0.0
		Vector2.LEFT:
			rotation_degrees = 270.0
		Vector2.RIGHT:
			rotation_degrees = 90.0

## health/hit #######################################################

func take_hit(opts={}):
	if is_dead:
		return
	var damage = opts.get("damage", 1)
	var body = opts.get("body")
	var direction = opts.get("direction")
	if not direction and body:
		if body.global_position.x < global_position.x:
			direction = Vector2.LEFT
		else:
			direction = Vector2.RIGHT
	else:
		direction = Vector2.RIGHT

	health -= damage
	health = clamp(health, 0, health)
	Hotel.check_in(self)
	machine.transit("KnockedBack", {direction=direction, dying=health <= 0})

## hitbox entered #######################################################

var bodies = []

func _on_body_entered(body):
	Log.prn("body entered", body)

	if machine.state.name in ["Idle", "Run"] and body.is_in_group("player"):
		bodies.append(body)

		# hurt_on_touch?
		if should_hurt_to_touch:
			body.take_hit({body=self})

		# should probably do this from each state's physics_process()
		if can_kick and machine.state.name in ["Idle", "Run"]:
			kick(body)

func _on_body_exited(body):
	bodies.erase(body)

########################################################
# kick

# should move this to the machine's idle and kick states

func _on_animation_finished():
	if anim.animation == "kick":
		machine.transit("Idle")

func _on_frame_changed():
	if anim.animation == "idle":
		if anim.frame in [3, 4, 5, 6]:
			for los in line_of_sights:
				U.update_los_facing(-1*facing_vector, los)
		else:
			for los in line_of_sights:
				U.update_los_facing(facing_vector, los)

	elif anim.animation == "kick" and anim.frame in [3, 4, 5, 6]:
		for b in bodies:
			if b.has_method("take_hit"):
				if not b in bodies_this_kick:
					Cam.hitstop("kickhit", 0.3, 0.1)
					bodies_this_kick.append(b)
					b.take_hit({body=self})

var bodies_this_kick = []

func kick(body):
	bodies_this_kick = []
	machine.transit("Kick", {body=body})
