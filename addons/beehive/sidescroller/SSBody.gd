@tool
extends CharacterBody2D
class_name SSBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"SSMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": [
			"idle", "run", "jump", "air", "fall",
			"knocked_back", "dying", "dead",]}})

## vars ###########################################################

# input vars

@export var display_name: String
@export var initial_health: int = 6
@export var bump_damage: int = 2
@export var defense: int = 1
@export var should_wander: bool
@export var should_patrol: bool

@export var run_speed: float = 10000
@export var air_speed: float = 9000 # horizontal movement in the air
@export var knockback_speed_y: float = 100
@export var knockback_speed_x: float = 30
@export var wander_speed: float = 4000

@export var jump_max_height: float = 100.0
@export var jump_min_height: float = 40.0
@export var jump_time: float = 0.3
@export var fall_time: float = 0.3

@onready var jump_velocity: float = ((2.0 * jump_max_height) / jump_time)
@onready var jump_gravity: float = ((2.0 * jump_max_height) / (jump_time * jump_time)) # ~1000
@onready var fall_gravity: float = ((2.0 * jump_max_height) / (fall_time * fall_time)) # ~2000
var gravity = 1000 # for use in non-jump states

# vars

var move_vector: Vector2
var facing_vector: Vector2
var health
var is_dead
var is_player

# nodes

var coll
var machine
var state_label
var anim
var cam_pof
var hurt_box
var nav_agent

## enter_tree ###########################################################

func _enter_tree():
	Hotel.book(self)

## ready ###########################################################

func _ready():
	Hotel.register(self)

	if is_in_group("player"):
		is_player = true
		should_wander = false
		should_patrol = false
	elif is_in_group("enemies"):
		is_player = false
		should_wander = true
		should_patrol = true
	else:
		is_player = false
		should_wander = true
		should_patrol = false

	if not Engine.is_editor_hint():
		machine = $SSMachine
		state_label = $StateLabel
		anim = $AnimatedSprite2D
		coll = $CollisionShape2D
		if get_node_or_null("CamPOF"):
			cam_pof = get_node("CamPOF")

		if get_node_or_null("NavigationAgent2D"):
			nav_agent = get_node("NavigationAgent2D")

		if get_node_or_null("HurtBox"):
			hurt_box = get_node("HurtBox")
			hurt_box.body_entered.connect(on_hurt_box_entered)
			hurt_box.body_exited.connect(on_hurt_box_exited)

		machine.transitioned.connect(_on_transit)
		machine.start()


func get_rect():
	if coll != null:
		var rect = coll.shape.get_rect()
		rect.position += coll.position + global_position
		return rect

## on_transit ###########################################################

func _on_transit(label):
	state_label.text = "[center]%s" % label

## hotel ###########################################################

func hotel_data():
	var d = {health=health, name=name, is_dead=is_dead}
	if not display_name in ["", null]: # yay types! woo!
		d["display_name"] = display_name
	return d

func check_out(data):
	health = Util.get_(data, "health", initial_health)
	is_dead = Util.get_(data, "is_dead", is_dead)
	display_name = Util.get_(data, "display_name", display_name)

## facing ###########################################################

func update_facing():
	# all art should face RIGHT by default
	anim.flip_h = facing_vector == Vector2.LEFT

func flip_facing():
	# assumes facing vector is always vec.left or vec.right
	facing_vector *= -1
	update_facing()

func face_body(body):
	var pos_diff = body.global_position - global_position
	if pos_diff.x > 0:
		facing_vector = Vector2.RIGHT
	elif pos_diff.x < 0:
		facing_vector = Vector2.LEFT

	update_facing()

## death ###########################################################

signal died()

func die(opts={}):
	is_dead = true
	Hotel.check_in(self)

## damage ###########################################################

func take_hit(hit_type, body):
	take_damage(hit_type, body)

	if health <= 0:
		die()
		machine.transit("Dying", {killed_by=body})
	else:
		machine.transit("KnockedBack", {knocked_by=body, hit_type=hit_type})

func take_damage(hit_type, body):
	var attack_damage
	match hit_type:
		"bump":
			attack_damage = body.bump_damage
		_:
			Debug.warn("using fallback damage (1)")
			attack_damage = 1
	var damage = attack_damage - defense
	health -= damage
	Hotel.check_in(self)

	# TODO restore sound on hurt?
	# if is_player:
	# 	DJZ.play(DJZ.S.playerhurt)

## recover health ###########################################################

# if no arg passed, recover _all_ health
func recover_health(h=null):
	if h == null:
		health = initial_health
	else:
		health += h
	Hotel.check_in(self)

	# TODO restore sound on heal
	# if is_player:
	# 	DJZ.play(DJZ.S.playerheal)
	# # force one-shot emission
	# heart_particles.set_emitting(true)
	# heart_particles.restart()

## hurt_box ###########################################################

var hurt_box_bodies = []

func on_hurt_box_entered(body):
	# TODO ignore other bodies
	# if body is SSBody: # can't write this in same-name class script
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in hurt_box_bodies:
			hurt_box_bodies.append(body)
			body.take_hit("bump", self)

func on_hurt_box_exited(body):
	hurt_box_bodies.erase(body)
