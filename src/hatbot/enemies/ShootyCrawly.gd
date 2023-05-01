extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var hitbox = $Hitbox
# @onready var spell = $Spell
@onready var front_ray = $FrontRay
@onready var los = $LineOfSight

signal died(me)
signal knocked_back(me)
signal fired_bullet(spell)

var death_animation = "dead"
var dying_animation = "hit"
var run_animation = "crawl"

var can_see_player

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

func _on_transitioned(_state_label):
	# Debug.prn(state_label)
	pass

func _on_death(_me):
	Cam.screenshake(0.1)
	# TODO goomba sounds
	DJZ.play(DJZ.soldierdead)
	Hotel.check_in(self)

func _on_knocked_back(_me):
	anim.play(dying_animation)
	if health <= 0:
		# TODO goomba sounds
		DJZ.play(DJZ.soldierdead)
	else:
		# TODO goomba sounds
		DJZ.play(DJZ.soldierhit)


########################################################
# hotel data

func hotel_data():
	var d = {
		name=name,
		position=global_position,
		facing=facing,
		crawl_on_side=crawl_on_side,
		}
	if health != null:
		d["health"] = health
	return d

func check_out(data):
	global_position = data.get("position", global_position)
	health = data.get("health", initial_health)
	facing = data.get("facing", facing)
	face(facing)

	crawl_on_side = data.get("crawl_on_side", crawl_on_side)
	if crawl_on_side:
		orient(crawl_on_side)

	if health <= 0:
		machine.transit("Dead", {ignore_side_effects=true})

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
	Util.update_h_flip(facing, front_ray)

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false
	Util.update_h_flip(facing, front_ray)

########################################################
# _physics_process

const SPEED = 15.0
const JUMP_VELOCITY = 0.0
const KNOCKBACK_VELOCITY = 0.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 0.0
const DYING_VELOCITY = 0.0
var GRAVITY = 0

var move_dir = Vector2.ZERO

var crawl_on_side
func _physics_process(_delta):
	if crawl_on_side == null:
		if is_on_wall_only():
			crawl_on_side = get_wall_normal()
		elif is_on_floor_only():
			crawl_on_side = Vector2.DOWN
		elif is_on_ceiling_only():
			crawl_on_side = Vector2.UP
		if crawl_on_side != null:
			orient(crawl_on_side)

	if Game.player and is_instance_valid(Game.player):
		# var player_pos = Game.player.global_position
		# los.target_position = to_local(player_pos)

		if los.is_colliding():
			var body = los.get_collider()
			if body.is_in_group("player"):
				can_see_player = true
			else:
				can_see_player = false

func orient(side):
	match(side):
		Vector2.UP:
			rotation_degrees = 180.0
		Vector2.DOWN:
			rotation_degrees = 0.0
		Vector2.LEFT:
			rotation_degrees = 270.0
		Vector2.RIGHT:
			rotation_degrees = 90.0

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
