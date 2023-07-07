@tool
extends SSEnemy

@onready var drop_pickup_scene = preload("res://src/spike/entities/BlobPickup.tscn")

func _get_configuration_warnings():
	return super._get_configuration_warnings()

func _ready():
	super._ready()

var dropped_drops = false

func _on_death(enemy):
	super._on_death(enemy)

	if dropped_drops == false:
		dropped_drops = true
		var drop = drop_pickup_scene.instantiate()
		drop.global_position = global_position
		await get_tree().create_timer(0.5).timeout
		Navi.current_scene.add_child.call_deferred(drop)
