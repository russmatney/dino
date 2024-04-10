extends CharacterBody2D

## vars ######################################################

@onready var state_label = $StateLabel
@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D

@export var run_speed := 5500
@export var drag_speed := 100
@export var air_speed: float = 5000 # horizontal movement in the air

@export var jump_max_height: float = 60.0
@export var jump_min_height: float = 30.0
@export var jump_time: float = 0.3
@export var fall_time: float = 0.2

@onready var jump_velocity: float = ((2.0 * jump_max_height) / jump_time)
@onready var jump_gravity: float = ((2.0 * jump_max_height) / (jump_time * jump_time)) # ~1000
@onready var fall_gravity: float = ((2.0 * jump_max_height) / (fall_time * fall_time)) # ~2000
@export var gravity := 1000

var move_vector: Vector2
var facing_vector: Vector2
var is_dead: bool

## ready ######################################################

func _ready():
	machine.transitioned.connect(on_transit)
	machine.start()

	Cam.request_camera({
		player=self,
		zoom_rect_min=250,
		proximity_min=50,
		proximity_max=250,
		})

## physics process ##########################################################

func _physics_process(_delta):
	move_vector = get_move_vector()

	if not Engine.is_editor_hint():
		if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
			# support strafing if a weapon is firing/we're plugged into something?
			if move_vector.x > 0:
				facing_vector = Vector2.RIGHT
			elif move_vector.x < 0:
				facing_vector = Vector2.LEFT
			update_facing()

## input ##########################################################

func _unhandled_input(event):
	# prevent input
	if block_control or is_dead or machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		return

	# exec action
	if Trolls.is_action(event):
		# stamp({scale=2.0, ttl=1.0, include_action_hint=true})
		# action_detector.execute_current_action()
		# action_detector.current_action()
		Cam.hitstop("player_hitstop", 0.5, 0.2)
		toss_plug()

	# action cycling
	if Trolls.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		# action_detector.cycle_prev_action()
	elif Trolls.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		# action_detector.cycle_next_action()

## transitions ######################################################

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.text = "[center]" + label + "[/center]"

func _on_animation_finished():
	if anim.animation == "from-bucket":
		anim.play("idle-standing")

## facing ##########################################################

func face_right():
	anim.flip_h = false
	facing_vector = Vector2.RIGHT

func face_left():
	anim.flip_h = true
	facing_vector = Vector2.LEFT

func update_facing():
	if facing_vector == Vector2.RIGHT:
		face_right()
	elif facing_vector == Vector2.LEFT:
		face_left()

## collision checks ##########################################################

func collision_check():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("spikes"):
			# take_hit({body=collider, damage=1, type="spikes"})
			return true

## get move vector, forced move to target ##########################################################################

var block_control = false
var forced_movement_target
var forced_movement_target_threshold = 10

func get_move_vector():
	if forced_movement_target != null:
		var towards_target = forced_movement_target - position
		var dist = towards_target.length()
		if dist >= forced_movement_target_threshold:
			return towards_target.normalized()
		else:
			return Vector2.ZERO
		# NOTE no movement can occur until forced_movement_target is unset
	else:
		return Trolls.move_vector()

func force_move_to_target(target_position):
	block_control = true
	forced_movement_target = target_position

func clear_forced_movement_target():
	block_control = false
	forced_movement_target = null


## toss plug ##########################################################

@onready var plug_source = $PlugSource
var tossed_plug_scene = preload("res://src/games/pluggs/plug/TossedPlug.tscn")

func toss_plug():
	var plug = tossed_plug_scene.instantiate()
	plug.global_position = plug_source.global_position
	U.add_child_to_level(self, plug)

	var dir = (facing_vector + Vector2(0, -0.7)).normalized()

	plug.toss(self, dir)
