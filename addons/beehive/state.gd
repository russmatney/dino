# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name State
extends Node

## input #####################################################################


func handle_input(event: InputEvent):
	print("Unhandled input received: ", event)


## process ################################################################


func process(_delta: float):
	pass


func physics_process(_delta: float):
	pass


## transitions ###################################################################

var machine = null


func enter(_ctx := {}):
	pass


func exit():
	pass
