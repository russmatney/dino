class_name Machine
extends Node

@export var initial_state := NodePath()
var state: State

var should_log = false

### ready #####################################################################


func _ready():
	await owner.ready

	if initial_state:
		state = get_node(initial_state)

	for child in get_children():
		# assign machine to states
		child.machine = self

		print("assigning owner: ", owner)
		# assign machine's owner as 'actor' in state fns
		child.actor = owner

		# initial state defaults to first child
		# (unless set via the inspector)
		if not state:
			state = child

	if state:
		state.enter()
		emit_signal("transitioned", state.name)


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
			print(
				owner,
				(
					"[Machine] Transit. Exiting '"
					+ state.name
					+ "', Entering '"
					+ next_state.name
					+ "'"
				)
			)
		state.exit()
		state = next_state
		next_state.enter(ctx)
		emit_signal("transitioned", next_state.name)
	else:
		print("Error! no next state! derp!", target_state_name, ctx)
