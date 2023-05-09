extends CharacterBody2D


@onready var machine = $BEUMachine
@onready var state_label = $StateLabel

## ready ###########################################################

func _ready():
	machine.transitioned.connect(_on_transit)
	machine.start()

	Cam.ensure_camera({player=self})
	Hood.ensure_hud()

	Hood.notif("Player ready!")

## on_transit ###########################################################

func _on_transit(label):
	Debug.pr(label)
	Debug.pr(machine.state)

	state_label.set_text("[center]%s" % label)

## input ###########################################################

func _unhandled_input(event):
	if Trolley.is_jump(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Jump")

## physics_process ###########################################################

var move_vector: Vector2

func _physics_process(_delta):
	move_vector = Trolley.move_dir()
