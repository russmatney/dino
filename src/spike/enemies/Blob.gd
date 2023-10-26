@tool
extends SSEnemy

@onready var drop_pickup_scene = preload("res://src/spike/entities/BlobPickup.tscn")
@export var drop_ingredient_type: SpikeData.Ingredient = SpikeData.Ingredient.GreyBlob

func _get_configuration_warnings():
	return super._get_configuration_warnings()

func _ready():
	super._ready()

func check_out(data):
	var pos = data.get("position", global_position)
	if pos != null and pos != Vector2.ZERO:
		global_position = pos
	health = data.get("health", initial_health)
	facing_vector = data.get("facing_vector", facing_vector)
	face(facing_vector)

	crawl_on_side = data.get("crawl_on_side", crawl_on_side)
	if crawl_on_side:
		orient_to_wall(crawl_on_side)

	# overwritten to prevent replaying from leaving enemies dead
	if health <= 0:
		health = initial_health

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
		Navi.add_child_to_current(drop)
