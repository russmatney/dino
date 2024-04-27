@tool
extends Object
class_name SpikeData

## zones ##########################################################

const zone_scenes = [
	# "res://src/games/spike/zones/ZoneGym.tscn",
	"res://src/games/spike/zones/BasicLevelOne.tscn",
	"res://src/games/spike/zones/PantryOne.tscn",
	"res://src/games/spike/zones/PantryTwo.tscn",
	"res://src/games/spike/zones/FlatLandOne.tscn",
	# "res://src/games/spike/zones/FlatLandTwo.tscn",
	"res://src/games/spike/zones/FinalZoneOne.tscn",
	"res://src/games/spike/zones/FinalZoneTwo.tscn",
	]

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

static var all_ingredients = {
	Ingredient.GreyBlob: IngredientData.mk({
		name="grey blob",
		display_type="GREY",
		anim_scene=preload("res://src/dino/pickups/orb/GreyBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.BlueBlob: IngredientData.mk({
		name="blue blob",
		display_type="BLUE",
		anim_scene=preload("res://src/dino/pickups/orb/BlueBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.GreenBlob: IngredientData.mk({
		name="green blob",
		display_type="GREEN",
		anim_scene=preload("res://src/dino/pickups/orb/GreenBlobAnim.tscn"),
		can_cook=true,
		}),
	Ingredient.RedBlob: IngredientData.mk({
		name="red blob",
		display_type="RED",
		anim_scene=preload("res://src/dino/pickups/orb/RedBlobAnim.tscn"),
		}),
	}
