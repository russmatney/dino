class_name Machine
extends Node

export var initial_state := NodePath()
var state: State

### ready #####################################################################


func _ready():
	yield(owner, "ready")

	if initial_state:
		state = get_node(initial_state)

	for child in get_children():
		# assign machine to states
		child.machine = self

		# initial state defaults to first child
		# (unless set via the inspector)
		if not state:
			state = child

	if state:
		state.enter()


### input #####################################################################


func _unhandled_input(ev):
	if state:
		state.handle_input(ev)


### process #####################################################################


func _process(delta):
	if state:
		state.process(delta)


func _physics_process(delta):
	if state:
		state.physics_process(delta)


## transitions ###################################################################

signal transitioned(state_name)


func transit(target_state_name: String, ctx: Dictionary = {}):
	var next_state
	for child in get_children():
		if child.name == target_state_name:
			next_state = child

	if next_state:
		print("Transit from :", state.name, " to: ", next_state.name)
		state.exit()
		state = next_state
		next_state.enter(ctx)
		emit_signal("transitioned", next_state.name)
	else:
		print("Error! no next state! derp!", target_state_name, ctx)
