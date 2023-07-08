@tool
extends DinoGame

func _ready():
	pause_menu_scene = load("res://src/spike/menus/PauseMenu.tscn")
	main_menu_scene = load("res://src/spike/menus/MainMenu.tscn")
	icon_texture = load("res://assets/sprites/Spike_icon.png")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/spike")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/spike/menus")

## player ##########################################################

var player_scene = preload("res://src/spike/player/Player.tscn")

func get_spawn_coords():
	return Metro.get_spawn_coords()

## zones ##########################################################

const zone_scenes = [
	# "res://src/spike/zones/ZoneGym.tscn",
	"res://src/spike/zones/FirstKitchen.tscn",
	]

## register ##########################################################

var first_zone

func register():
	register_menus()

	Debug.pr("Registering Spike Zones")
	Hotel.add_root_group(Metro.zones_group)

	for sfp in zone_scenes:
		Hotel.book(sfp)

	if first_zone == null:
		first_zone = zone_scenes[0]

	var zones = Hotel.query({"group": Metro.zones_group})

	Debug.pr("Spike registered", len(zones), "zones and first zone ", first_zone)

## start ##########################################################

func start():
	Debug.prn("Starting Spike!")

	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	Metro.update_zone()

## ingredients / meals ##########################################################

class IngredientData:
	var name: String
	var anim_scene: PackedScene

	var _can_cook: bool
	var _can_be_delivered: bool

	func can_cook():
		return _can_cook

	func can_be_delivered():
		return _can_be_delivered

	static func mk(opts={}):
		var d = IngredientData.new()
		d.name = opts.get("name")
		d.anim_scene = opts.get("anim_scene")
		d._can_cook = opts.get("can_cook", false)
		d._can_be_delivered = opts.get("can_be_delivered", false)
		return d

enum Ingredient { GreyBlob, BlueBlob, RedBlob, GreenBlob }

var all_ingredients = {
	Ingredient.GreyBlob: IngredientData.mk({name="grey blob",
		anim_scene=preload("res://src/spike/ingredients/GreyBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.BlueBlob: IngredientData.mk({name="blue blob",
		anim_scene=preload("res://src/spike/ingredients/BlueBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.GreenBlob: IngredientData.mk({name="green blob",
		anim_scene=preload("res://src/spike/ingredients/GreenBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.RedBlob: IngredientData.mk({name="red blob",
		anim_scene=preload("res://src/spike/ingredients/RedBlobAnim.tscn"),
		can_be_delivered=true,
		}),
	}
