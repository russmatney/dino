class_name State
extends Node

## vars ###################################################################

var machine: Machine
var actor: Node2D

## transitions ###################################################################

func enter(_ctx := {}):
	Log.warn("WARN: enter func expected to be overwritten")

func exit():
	pass

func transit(next_state, arg = {}):
	machine.transit(next_state, arg)

## input #####################################################################

func unhandled_input(event: InputEvent):
	pass

## process ################################################################

# if these names matched the usual _process,
# they'd actually be called by the engine,
# not our state machine
func process(_delta: float):
	pass

func physics_process(_delta: float):
	pass

## properties ################################################################

## state meta

# can be the machine's initial state
func can_be_initial_state():
	return false

## player props

# should ignore inputs while in this state
func ignore_input() -> bool:
	return false

# can perform an action-detector action
func can_act() -> bool:
	return true

## shared props

# should update the facing direction to match the movement direction
func face_movement_direction() -> bool:
	return false

# can bump an entity in its hurtbox
func can_bump() -> bool:
	return true

# can attack an entity in its hitbox
func can_attack() -> bool:
	return false

# can ignore an attack (in take_hit)
func should_ignore_hit() -> bool:
	return false

# can hop based on various triggers
func can_hop() -> bool:
	return false

## common callbacks ################################################################

# fired from actor.anim
func on_animation_finished():
	pass

# fired from actor.anim
func on_frame_changed():
	pass
