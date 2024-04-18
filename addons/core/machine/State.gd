class_name State
extends Node

## vars ###################################################################

var machine: Machine
var actor: Node2D

## transitions ###################################################################

func enter(_ctx := {}):
	Log.pr("WARN: enter func expected to be overwritten")

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

func can_be_initial_state():
	return false

# should ignore inputs while in this state
func ignore_input() -> bool:
	return false

# should update the facing direction to match the movement direction
func face_movement_direction() -> bool:
	return false

# can bump enemies in the actor's hurtbox
func can_bump() -> bool:
	return true

# can perform an action-detector action
func can_act() -> bool:
	return true

# can enemy attack a player in its own hitbox
func can_attack() -> bool:
	return false

# can boss ignore a player attack
func should_ignore_hit() -> bool:
	return false

## common callbacks ################################################################

# fired from actor.anim
func on_animation_finished():
	pass

# fired from actor.anim
func on_frame_changed():
	pass
