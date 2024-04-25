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

signal transitioning(from_state, to_state)
signal transitioned(state_name)

# only set during transition
var next_state

## to pretty #####################################################################

func to_pretty():
	return [actor, state, {
			should_log=should_log,
			is_transitioning=is_transitioning,
			is_started=is_started,
		}]

## ready #####################################################################

func _ready():
	if not len(get_children()) > 0:
		Log.warn("Machine with no states (children), cannot setup")
		return

	if not actor:
		# set the parent as the 'actor' in the states
		var p = get_parent()
		p.ready.connect(func(): start({actor=p}))

## start #####################################################################

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
		if not state and child.can_be_initial_state():
			state = child

		if actor.get("anim") and actor.anim != null:
			if not actor.anim.animation_finished.is_connected(on_animation_finished):
				actor.anim.animation_finished.connect(on_animation_finished)
			if not actor.anim.frame_changed.is_connected(on_frame_changed):
				actor.anim.frame_changed.connect(on_frame_changed)

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

## transitions ###################################################################

func transit(target_state_name: String, ctx: Dictionary = {}):
	if not is_started:
		Log.warn("machine transit attempted before machine started")
		return

	# TODO expected behavior for transitioning to the current state?
	is_transitioning = true
	for child in get_children():
		if child.name == target_state_name:
			next_state = child

	if next_state:
		ctx["previous_state"] = state.name

		transitioning.emit(state.name, next_state.name)
		if should_log:
			Log.info(owner, "Transition. Exiting '%s', Entering '%s'" % [state.name, next_state.name])
		# note, machine.next_state is bound during .exit() call
		state.exit()
		state = next_state
		next_state.enter(ctx)
		transitioned.emit(next_state.name)
	else:
		transitioning.emit(state.name, null)
		Log.err("Error! no next state! derp!", target_state_name, ctx)
		transitioned.emit(null)
	next_state = null
	is_transitioning = false

## input #####################################################################

func _unhandled_input(ev):
	if state and not is_transitioning:
		state.unhandled_input(ev)

## process #####################################################################

func _process(delta):
	if state and not is_transitioning:
		state.process(delta)

func _physics_process(delta):
	if state and not is_transitioning:
		state.physics_process(delta)

## animation #####################################################################

func on_animation_finished():
	if state and not is_transitioning:
		state.on_animation_finished()

func on_frame_changed():
	if state and not is_transitioning:
		state.on_frame_changed()

## property checks #####################################################################

# should ignore inputs while in this state
func ignore_input() -> bool:
	if state and not is_transitioning:
		return state.ignore_input()
	return true

# should update the facing direction to match the movement direction
func face_movement_direction() -> bool:
	if state and not is_transitioning:
		return state.face_movement_direction()
	return false

# can bump enemies in the actor's hurtbox
func can_bump() -> bool:
	if state and not is_transitioning:
		return state.can_bump()
	return false

# can perform an action-detector action
func can_act() -> bool:
	if state and not is_transitioning:
		return state.can_act()
	return false

# can enemy attack a player in its own hitbox
func can_attack() -> bool:
	if state and not is_transitioning:
		return state.can_attack()
	return false

# can boss ignore a player attack
func should_ignore_hit() -> bool:
	if state and not is_transitioning:
		return state.should_ignore_hit()
	return true

# can hop
func can_hop() -> bool:
	if state and not is_transitioning:
		return state.can_hop()
	return false
