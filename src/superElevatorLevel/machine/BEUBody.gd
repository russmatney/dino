@tool
extends CharacterBody2D
class_name BEUBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"BEUMachine", "StateLabel", "PunchBox", "GrabBox"]})


#############################################################

@export var jump_speed: int = 10000
@export var throw_speed: int = 12000

var machine
var state_label
var punch_box
var grab_box

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		machine = $BEUMachine
		state_label = $StateLabel
		punch_box = $PunchBox
		grab_box = $GrabBox

		machine.transitioned.connect(_on_transit)
		machine.start()

		punch_box.body_entered.connect(on_punchbox_body_entered)
		punch_box.body_exited.connect(on_punchbox_body_exited)

		grab_box.body_entered.connect(on_grabbox_body_entered)
		grab_box.body_exited.connect(on_grabbox_body_exited)


## on_transit ###########################################################

func _on_transit(label):
	state_label.set_text("[center]%s" % label)


## physics_process ###########################################################

var move_vector: Vector2
var facing_vector: Vector2

func _physics_process(_delta):
	if move_vector.abs().length() > 0:
		facing_vector = move_vector
		update_facing()

func update_facing():
	Util.update_h_flip(facing_vector, punch_box)
	Util.update_h_flip(facing_vector, grab_box)


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
