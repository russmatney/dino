extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _input(event):
#	if event is InputEventMouseMotion:
#		global_position = event.position
		
func _process(delta):
	global_position = get_global_mouse_position()
