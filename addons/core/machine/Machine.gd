class_name Machine
extends Node

### vars #####################################################################

@export var initial_state := NodePath()

# state
var state: State
var actor: Node2D

# opts
var should_log = false
var is_transitioning = false
var is_started = false

### to pretty #####################################################################

func to_pretty():
	return [actor, state, {
			should_log=should_log,
			is_transitioning=is_transitioning,
			is_started=is_started,
		}]

### ready #####################################################################

func _ready():
	if not len(get_children()) > 0:
		Log.warn("Machine with no states (children), cannot setup")
		return

	if not actor:
		# set the parent as the 'actor' in the states
		var p = get_parent()
		p.ready.connect(func():
			Log.pr("starting machine with parent", p)
			start({actor=p}))

# should only be called when the owner is ready
# b/c the initial state's enter() is called, which expects
# things like actor.anim to exist.
func start(opts={}):
	actor = opts.get("actor", get_owner())

	is_transitioning = true

	if initial_state:
		state = get_node(initial_state)

	for child: State in get_children():
		# assign machine to states
		child.machine = self
		# assign machine's owner as 'actor' in state fns
		# could also pass the actor in
		child.actor = actor

		# states opt-in to being 'default'
		if not state and child.can_be_initial_state:
			state = child

		if actor.get("anim") and actor.anim != null:
			actor.anim.animation_finished.connect(child.on_animation_finished)
			actor.anim.frame_changed.connect(child.on_frame_changed)

	# still no state? just set the first child
	if not state:
		for child in get_children():
			state = child
			break

	if state:
		state.enter(opts)
		transitioned.emit(state.name)

	is_transitioning = false
	is_started = true

### input #####################################################################

func _unhandled_input(ev):
	if state and not is_transitioning:
		state.unhandled_input(ev)

### process #####################################################################

func _process(delta):
	if state and not is_transitioning:
		state.process(delta)

func _physics_process(delta):
	if state and not is_transitioning:
		state.physics_process(delta)

## transitions ###################################################################

signal transitioning(from_state, to_state)
signal transitioned(state_name)

func transit(target_state_name: String, ctx: Dictionary = {}):
	is_transitioning = true
	var next_state
	for child in get_children():
		if child.name == target_state_name:
			next_state = child

	if next_state:
		transitioning.emit(state.name, next_state.name)
		if should_log:
			Log.pr(owner, "Transition. Exiting '%s', Entering '%s'" % [state.name, next_state.name])
		state.exit()
		state = next_state
		next_state.enter(ctx)
		transitioned.emit(next_state.name)
	else:
		transitioning.emit(state.name, null)
		Log.err("Error! no next state! derp!", target_state_name, ctx)
		transitioned.emit(null)
	is_transitioning = false
