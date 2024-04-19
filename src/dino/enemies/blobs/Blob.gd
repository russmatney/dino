@tool
extends SSEnemy

@onready var drop_pickup_scene = preload("res://src/dino/pickups/BlobPickup.tscn")
@export var drop_ingredient_type: SpikeData.Ingredient = SpikeData.Ingredient.GreyBlob

func _get_configuration_warnings():
	return super._get_configuration_warnings()

func _ready():
	super._ready()
	died.connect(_on_death)

# dim-witted daniel dipwell dropped drops down under dover.
var did_drop_drops = false

func _on_death(_enemy):
	if did_drop_drops == false:
		did_drop_drops = true
		var drop = drop_pickup_scene.instantiate()
		# pass ingredient data along
		drop.ingredient_type = drop_ingredient_type
		drop.global_position = global_position
		await get_tree().create_timer(0.5).timeout
		U.add_child_to_level(self, drop)
