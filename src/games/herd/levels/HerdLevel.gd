extends DinoLevel
class_name HerdLevel

## ready #####################################################

func _ready():
	var quest = FetchSheepQuest.new()
	add_child(quest)

	super._ready()

func setup_level():
	# TODO move conversion to HerdLevelGen
	var tilemaps = get_node_or_null("Tilemaps")
	if tilemaps:
		for ch in tilemaps.get_children():
			if ch.is_in_group("pen"):
				create_pen(ch)

	super.setup_level()

func create_pen(tilemap):
	var area = Reptile.to_area2D(tilemap)
	area.add_to_group("pen", true)
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	area.set_collision_mask_value(10, true) # 10 for npc
	$Entities.add_child(area)
