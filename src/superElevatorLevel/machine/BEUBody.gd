@tool
extends CharacterBody2D
class_name BEUBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"BEUMachine", "StateLabel",
		"PunchBox", "GrabBox", "NoticeBox",]})


## vars #############################################################

@export var should_wander: bool = false
@export var should_notice: bool = false
@export var jump_speed: int = 10000
@export var throw_speed: int = 12000
@export var wander_speed: int = 4000
@export var walk_speed: int = 10000
@export var max_attackers: int = 1

var machine
var state_label
var punch_box
var grab_box
var notice_box

var move_vector: Vector2
var facing_vector: Vector2

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		machine = $BEUMachine
		state_label = $StateLabel
		punch_box = $PunchBox
		grab_box = $GrabBox
		notice_box = $NoticeBox

		machine.transitioned.connect(_on_transit)
		machine.start()

		punch_box.body_entered.connect(on_punchbox_body_entered)
		punch_box.body_exited.connect(on_punchbox_body_exited)

		grab_box.body_entered.connect(on_grabbox_body_entered)
		grab_box.body_exited.connect(on_grabbox_body_exited)

		notice_box.body_entered.connect(on_noticebox_body_entered)
		notice_box.body_exited.connect(on_noticebox_body_exited)


## on_transit ###########################################################

func _on_transit(label):
	state_label.set_text("[center]%s" % label)


## physics_process ###########################################################

func _physics_process(_delta):
	if move_vector.abs().length() > 0:
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()


## facing ###########################################################

func update_facing():
	Util.update_h_flip(facing_vector, punch_box)
	Util.update_h_flip(facing_vector, grab_box)
	Util.update_h_flip(facing_vector, notice_box)

func face_body(body):
	var pos_diff = body.global_position - global_position
	if pos_diff.x > 0:
		facing_vector = Vector2.RIGHT
	elif pos_diff.x < 0:
		facing_vector = Vector2.LEFT

	update_facing()


## punching ###########################################################

func punch():
	var did_hit
	for body in punch_box_bodies:
		if "machine" in body:
			body.machine.transit("Punched")
			did_hit = true
	return did_hit

func kick():
	var did_hit
	for body in punch_box_bodies:
		if "machine" in body:
			body.machine.transit("Kicked", {direction=facing_vector})
			did_hit = true
	return did_hit

var punch_box_bodies = []

func on_punchbox_body_entered(body):
	if not body in punch_box_bodies:
		punch_box_bodies.append(body)

func on_punchbox_body_exited(body):
	punch_box_bodies.erase(body)


## grabbing ###########################################################

func grab():
	var body = Util.nearest_node(self, grab_box_bodies)
	if body != null and "machine" in body:
		body.machine.transit("Grabbed", {grabbed_by=body})
		machine.transit("Grab", {grabbed=body})

var grab_box_bodies = []

func on_grabbox_body_entered(body):
	if not body in grab_box_bodies:
		grab_box_bodies.append(body)

	if len(grab_box_bodies) > 0 and machine.state.name in ["Walk"]:
		grab()

func on_grabbox_body_exited(body):
	grab_box_bodies.erase(body)


## attackers ###########################################################

func ready_for_new_attacker():
	return len(attackers) < max_attackers

var attackers = []

func add_attacker(body):
	if not body in attackers:
		attackers.append(body)

func remove_attacker(body):
	attackers.erase(body)


## noticebox ###########################################################

var notice_box_bodies = []

func on_noticebox_body_entered(body):
	if not body in notice_box_bodies:
		notice_box_bodies.append(body)

func on_noticebox_body_exited(body):
	notice_box_bodies.erase(body)
