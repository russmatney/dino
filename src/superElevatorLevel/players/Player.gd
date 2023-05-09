extends CharacterBody2D


@onready var machine = $BEUMachine
@onready var state_label = $StateLabel
@onready var punch_box = $PunchBox
@onready var grab_box = $GrabBox

## ready ###########################################################

func _ready():
	machine.transitioned.connect(_on_transit)
	machine.start()

	Cam.ensure_camera({player=self})
	Hood.ensure_hud()

	Hood.notif("Player ready!")

	punch_box.body_entered.connect(on_punchbox_body_entered)
	punch_box.body_exited.connect(on_punchbox_body_exited)

	grab_box.body_entered.connect(on_grabbox_body_entered)
	grab_box.body_exited.connect(on_grabbox_body_exited)


## on_transit ###########################################################

func _on_transit(label):
	state_label.set_text("[center]%s" % label)

## input ###########################################################

func _unhandled_input(event):
	if Trolley.is_jump(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Jump")
		return

	if Trolley.is_attack(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Punch")
		return

## physics_process ###########################################################

var move_vector: Vector2
var facing_vector: Vector2

func _physics_process(_delta):
	move_vector = Trolley.move_dir()

	if move_vector.abs().length() > 0:
		facing_vector = move_vector
		update_facing()

func update_facing():
	Util.update_h_flip(facing_vector, punch_box)
	Util.update_h_flip(facing_vector, grab_box)

## punching ###########################################################

func punch():
	for body in punch_box_bodies:
		if "machine" in body:
			body.machine.transit("Punched")

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
