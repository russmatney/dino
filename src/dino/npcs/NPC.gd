extends CharacterBody2D
class_name NPC

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"SSNPCMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": ["idle",]}})

## vars ###########################################################

@export var speed = 20.0
@export var gravity = 1000
@export var show_debug = false

var facing_vector = Vector2.RIGHT
var move_vector

# nodes

@onready var anim = $AnimatedSprite2D
@onready var machine = $SSNPCMachine
@onready var state_label = $StateLabel

var nav_agent: NavigationAgent2D
var pcam: PhantomCamera2D

var front_ray
var low_los
var high_los
var line_of_sights = []

## ready ###########################################################

func _ready():
	# instead of node-names, could seek for child-of-type
	U.set_optional_nodes(self, {
		nav_agent="NavigationAgent2D",
		front_ray="FrontRay",
		low_los="LowLineOfSight",
		high_los="HighLineOfSight",
		pcam="PhantomCamera2D",
		})

	if low_los and high_los:
		line_of_sights = [low_los, high_los]

	machine.transitioned.connect(_on_transit)

	if state_label:
		if show_debug:
			state_label.set_visible(true)
		else:
			state_label.set_visible(false)

## on transit ####################################################

func _on_transit(label):
	if state_label and state_label.visible:
		state_label.text = label

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
	U.update_h_flip(facing_vector, front_ray)
	for los in line_of_sights:
		U.update_los_facing(facing_vector, los)
