# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name Machine
extends Node

export var initial_state := NodePath()
onready var state: State = get_node(initial_state)

### ready #####################################################################


func _ready():
	yield(owner, "ready")

	for child in get_children():
		# assign machine to states
		child.machine = self
	state.enter()


### input #####################################################################


func _unhandled_input(ev):
	state.handle_input(ev)


### process #####################################################################


func _process(delta):
	state.process(delta)


func _physics_process(delta):
	state.physics_process(delta)


## transitions ###################################################################

signal transitioned(state_name)


func transition_to(target_state_name: String, ctx: Dictionary = {}):
	var next_state
	for child in get_children():
		if child.name == target_state_name:
			next_state = child

	if next_state:
		state.exit()
		state.enter(ctx)
		emit_signal("transitioned", state.name)
