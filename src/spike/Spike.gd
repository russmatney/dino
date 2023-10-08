@tool
extends DinoGame

## player ##########################################################

var player_scene = preload("res://src/spike/player/Player.tscn")

func get_spawn_coords():
	return Metro.get_spawn_coords()

## zones ##########################################################

const zone_scenes = [
	# "res://src/spike/zones/ZoneGym.tscn",
	"res://src/spike/zones/BasicLevelOne.tscn",
	"res://src/spike/zones/PantryOne.tscn",
	"res://src/spike/zones/PantryTwo.tscn",
	"res://src/spike/zones/FlatLandOne.tscn",
	# "res://src/spike/zones/FlatLandTwo.tscn",
	"res://src/spike/zones/FinalZoneOne.tscn",
	"res://src/spike/zones/FinalZoneTwo.tscn",
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

func start(_opts={}):
	Debug.prn("Starting Spike!")

	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	Metro.update_zone()

func handle_level_complete():
	var curr_level_idx = zone_scenes.find(Navi.current_scene.scene_file_path)
	var next_level_idx = curr_level_idx + 1
	if next_level_idx < zone_scenes.size():
		var next_level = zone_scenes[next_level_idx]
		Metro.load_zone(next_level)
	else:
		Navi.show_win_menu()

## ingredients / meals ##########################################################

class IngredientData:
	var name: String
	var display_type: String
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
		d.display_type = opts.get("display_type")
		d.anim_scene = opts.get("anim_scene")
		d._can_cook = opts.get("can_cook", false)
		# all can be delivered for now! delivery zone determines acceptance
		d._can_be_delivered = true
		return d

enum Ingredient { GreyBlob, BlueBlob, RedBlob, GreenBlob }

var all_ingredients = {
	Ingredient.GreyBlob: IngredientData.mk({
		name="grey blob",
		display_type="GREY",
		anim_scene=preload("res://src/spike/ingredients/GreyBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.BlueBlob: IngredientData.mk({
		name="blue blob",
		display_type="BLUE",
		anim_scene=preload("res://src/spike/ingredients/BlueBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.GreenBlob: IngredientData.mk({
		name="green blob",
		display_type="GREEN",
		anim_scene=preload("res://src/spike/ingredients/GreenBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.RedBlob: IngredientData.mk({
		name="red blob",
		display_type="RED",
		anim_scene=preload("res://src/spike/ingredients/RedBlobAnim.tscn"),
		}),
	}
