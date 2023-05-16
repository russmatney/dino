@tool
extends CharacterBody2D
class_name SSBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"SSMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": ["idle", "run"]}})

## vars ###########################################################

# input vars

@export var display_name: String
@export var initial_health: int = 6
@export var jump_speed: int = 10000
@export var run_speed: int = 10000

# vars

var move_vector: Vector2
var facing_vector: Vector2
var health
var is_dead

# nodes

var machine
var state_label
var anim
var cam_pof

## enter_tree ###########################################################

func _enter_tree():
	Hotel.book(self)

## ready ###########################################################

func _ready():
	Hotel.register(self)

	if not Engine.is_editor_hint():
		machine = $SSMachine
		state_label = $StateLabel
		anim = $AnimatedSprite2D
		if get_node_or_null("CamPOF"):
			cam_pof = get_node("CamPOF")

		machine.transitioned.connect(_on_transit)
		machine.start()

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
	machine.transit("Dying")
