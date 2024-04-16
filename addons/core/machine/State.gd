class_name State
extends Node

## vars ###################################################################

var machine: Machine
var actor: Node2D
var can_be_initial_state = false

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

func ignore_inputs():
	pass

## common callbacks ################################################################

# fired from actor.anim
func on_animation_finished():
	pass

# fired from actor.anim
func on_frame_changed():
	pass
