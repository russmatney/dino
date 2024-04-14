class_name State
extends Node

# set in machine._ready()
var actor = null

## transitions ###################################################################

var machine = null


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

