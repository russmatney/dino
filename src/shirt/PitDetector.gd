extends Area2D
class_name PitDetector

func _ready():
	activate()

func deactivate():
	set_collision_layer_value(14, false)

func activate():
	set_collision_layer_value(14, true)
