class_name Machine
extends Node

@export var initial_state := NodePath()
var state: State

var should_log = false

### ready #####################################################################


# should only be called when the owner is ready
func start():
	Debug.prn("[Start] actor: ", owner)

	if initial_state:
		state = get_node(initial_state)

	for child in get_children():
		# assign machine to states
		child.machine = self
		# assign machine's owner as 'actor' in state fns
		child.actor = owner

		# initial state defaults to first child
		# (unless set via the inspector)
		if not state:
			state = child

	if state:
		state.enter()
		transitioned.emit(state.name)


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
		# TODO warn a mofo that this isn't checked _physics_process
		state.physics_process(delta)


## transitions ###################################################################

signal transitioned(state_name)


func transit(target_state_name: String, ctx: Dictionary = {}):
	var next_state
	for child in get_children():
		if child.name == target_state_name:
			next_state = child

	if next_state:
		if should_log:
			Debug.prn(
				owner,
				(
					"Transition. Exiting '"
					+ state.name
					+ "', Entering '"
					+ next_state.name
					+ "'"
				)
			)
		state.exit()
		state = next_state
		next_state.enter(ctx)
		transitioned.emit(next_state.name)
	else:
		Debug.err("Error! no next state! derp!", target_state_name, ctx)