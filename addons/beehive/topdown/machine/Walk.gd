extends State

## enter ###########################################################

func enter(_opts = {}):
	pass


## exit ###########################################################

func exit():
	pass


## input ###########################################################

func unhandled_input(_event):
	pass


## process ###########################################################

func process(_delta):
	pass


## physics ###########################################################

func physics_process(_delta):
	actor.move_and_slide()

