extends Object
class_name SpikeData

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

## ingredients / meals ##########################################################

# TODO autoloads for data? enums? maybe move this to a type/class elsewhere, maybe a pandora entity

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
