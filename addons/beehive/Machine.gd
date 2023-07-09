class_name Machine
extends Node

@export var initial_state := NodePath()
var state: State

var should_log = false
var transitioning = false
var is_started = false

### ready #####################################################################


# should only be called when the owner is ready
func start(opts={}):
	Debug.prn("[Start] actor: ", owner, opts)
	transitioning = true

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
		state.enter(opts)
		transitioned.emit(state.name)
	transitioning = false
	is_started = true


### input #####################################################################


func _unhandled_input(ev):
	if state and not transitioning:
		state.unhandled_input(ev)


### process #####################################################################


func _process(delta):
	if state and not transitioning:
		state.process(delta)


func _physics_process(delta):
	if state and not transitioning:
		state.physics_process(delta)


## transitions ###################################################################

signal transitioned(state_name)


func transit(target_state_name: String, ctx: Dictionary = {}):
	transitioning = true
	var next_state
	for child in get_children():
		if child.name == target_state_name:
			next_state = child

	if next_state:
		if should_log:
			Debug.prn(owner, "Transition. Exiting '%s', Entering '%s'" % [state.name, next_state.name])
		state.exit()
		state = next_state
		next_state.enter(ctx)
		transitioned.emit(next_state.name)
	else:
		Debug.err("Error! no next state! derp!", target_state_name, ctx)
	transitioning = false
