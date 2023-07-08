@tool
extends SSEnemy

@onready var drop_pickup_scene = preload("res://src/spike/entities/BlobPickup.tscn")
@export var drop_ingredient_type: Spike.Ingredient = Spike.Ingredient.GreyBlob

func _get_configuration_warnings():
	return super._get_configuration_warnings()

func _ready():
	super._ready()

# dim-witted daniel dipwell dropped drops down under dover.
var did_drop_drops = false

func _on_death(enemy):
	super._on_death(enemy)

	if did_drop_drops == false:
		did_drop_drops = true
		var drop = drop_pickup_scene.instantiate()
		# pass ingredient data along
		drop.ingredient_type = drop_ingredient_type
		drop.global_position = global_position
		await get_tree().create_timer(0.5).timeout
		Navi.current_scene.add_child.call_deferred(drop)
