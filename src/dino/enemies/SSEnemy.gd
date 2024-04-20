@tool
extends CharacterBody2D
class_name SSEnemy

## config warnings ###########################################################

func _get_configuration_warnings():
	var warns = U._config_warning(self, {expected_nodes=[
		"SSEnemyMachine", "StateLabel", "AnimatedSprite2D", "Hitbox"
		], expected_animations={"AnimatedSprite2D": [
			"idle", "run", "knocked_back", "dying", "dead",
			# "laughing", "kick"
			]}})
	if should_kick_player:
		warns.append_array(U._config_warning(self, {expected_animations={"AnimatedSprite2D": ["kick"]}}))
	return warns

## vars ###########################################################

@export var speed = 20.0
@export var gravity = 1000
@export var jump_velocity = -100.0
@export var knockback_velocity = -100.0
@export var knockback_velocity_horizontal = 10.0
@export var dying_velocity = -200.0
@export var bump_damage = 1

@export var initial_health = 1

@export var should_crawl_on_walls = false
@export var should_see_player = false
@export var should_kick_player = false
@export var should_hurt_to_touch = false
@export var should_hop = false

@export var show_debug = false

@export var drops: Array[DropData]

var health
var is_dead
var can_see_player
var facing_vector = Vector2.RIGHT
var move_vector

var crawl_on_side

var did_drop_drops = false

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

var hopbox

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

var max_y: float = 5000.0


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
			hopbox="Hopbox",
			})

		if hopbox:
			hopbox.body_entered.connect(on_hopbox_entered)
			hopbox.body_exited.connect(on_hopbox_exited)

		if skull_particles:
			skull_particles.set_emitting(false)

		if low_los and high_los:
			line_of_sights = [low_los, high_los]

		machine.transitioned.connect(_on_transit)

		Cam.add_offscreen_indicator(self, {
			# could instead depend on a fn like this directly on the passed node
			is_active=func(): return not is_dead})

	Hotel.register(self)

	hitbox.body_entered.connect(_on_hitbox_body_entered)
	hitbox.body_exited.connect(_on_hitbox_body_exited)

	if state_label:
		if show_debug:
			state_label.set_visible(true)
		else:
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

## process ####################################################

func _process(_delta):
	if get_global_position().y >= max_y and not is_dead:
		die()

	# is this expensive? (could limit with some min player/enemy distance)
	var player = Dino.current_player_node()
	if player and is_instance_valid(player) and should_see_player and los:
		var player_pos = player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			var body = los.get_collider()
			if body.is_in_group("player"):
				can_see_player = true

				# TODO should fire at player?

			else:
				can_see_player = false


## on transit ####################################################

func _on_transit(label):
	if state_label and state_label.visible:
		state_label.text = label

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
	for _los in line_of_sights:
		U.update_los_facing(facing_vector, _los)

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

## hitbox #######################################################

var hitbox_bodies = []

func _on_hitbox_body_entered(body):
	Log.prn("body entered", body)

	if body.is_in_group("player"):
		hitbox_bodies.append(body)

		# hurt_on_touch?
		if should_hurt_to_touch and machine.can_bump():
			body.take_hit({body=self, type="bump"})

		# TODO kick is specific, do we want a generic attack?
		# should probably do this from each state's physics_process()
		if should_kick_player and machine.can_attack():
			# this body isn't used at the moment
			machine.transit("Kick", {body=body})

func _on_hitbox_body_exited(body):
	hitbox_bodies.erase(body)

## hopbox #######################################################

var hopbox_bodies = []

# player hurting another body by touching...
func on_hopbox_entered(body):
	if should_hop and not body.is_dead and machine.can_hop():
		if not body in hopbox_bodies:
			hopbox_bodies.append(body)
			machine.transit("Jump")

func on_hopbox_exited(body):
	hopbox_bodies.erase(body)

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
	DJZ.play(DJZ.S.enemy_hit)
	Hotel.check_in(self)

	machine.transit("KnockedBack", {direction=direction, dying=health <= 0})

## die ####################################################

func die():
	is_dead = true
	died.emit(self)
	Hotel.check_in(self)
	Cam.screenshake(0.1)
	DJZ.play(DJZ.S.soldierdead)
	# DJZ.play(DJZ.S.enemy_dead)
	if skull_particles:
		skull_particles.set_emitting(true)

	if not did_drop_drops:
		did_drop_drops = true

		await get_tree().create_timer(0.3).timeout
		if not drops.is_empty():
			for drop in drops:
				DropData.add_drop(self, drop)


func stun():
	machine.transit("Stunned")
