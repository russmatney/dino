@tool
extends SSEnemy

@onready var drop_pickup_scene = preload("res://src/spike/entities/BlobPickup.tscn")

func _get_configuration_warnings():
	return super._get_configuration_warnings()

func _ready():
	super._ready()


func _on_death(enemy):
	super._on_death(enemy)

	var drop = drop_pickup_scene.instantiate()
	drop.global_position = global_position
	Navi.current_scene.add_child(drop)
