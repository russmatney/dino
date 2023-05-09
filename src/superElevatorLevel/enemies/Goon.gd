extends CharacterBody2D

@onready var machine = $BEUMachine
@onready var state_label = $StateLabel

## ready ###########################################################

func _ready():
	machine.transitioned.connect(_on_transit)
	machine.start()
	Hood.notif("Goon ready!")

## on_transit ###########################################################

func _on_transit(label):
	Debug.pr(label)
	Debug.pr(machine.state)

	state_label.set_text("[center]%s" % label)

## movement ###########################################################

var move_vector: Vector2
