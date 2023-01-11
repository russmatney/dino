class_name State
extends Node

# set in machine._ready()
var actor = null

## input #####################################################################


func handle_input(event: InputEvent):
	pass


## process ################################################################


# if these names matched the usual _process,
# they'd actually be called by the engine,
# not our state machine
func process(_delta: float):
	pass


func physics_process(_delta: float):
	pass


## transitions ###################################################################

var machine = null


func enter(_ctx := {}):
	print("WARN: enter func expected to be overwritten")
	pass


func exit():
	pass


func transit(next_state, arg = {}):
	machine.transit(next_state, arg)
