@tool
extends RepTileMap

@export var add_areas_to_owner = false
var generated_group = "_generated"
var pit_detector_parent

## ready ##################################################################

func _ready():
	pit_detector_parent = get_parent()
	ensure_pit_detectors()

## ensure_pit_detectors ##################################################################

func ensure_pit_detectors():
	U.free_children_in_group(pit_detector_parent, generated_group)

	for cells in Reptile.cell_clusters(self):
		create_pit_detector(cells)

## create_pit_detector ##################################################################

func create_pit_detector(cells):
	var coll_polygon = CollisionPolygon2D.new()
	coll_polygon.name = "CollisionPolygon2D"
	coll_polygon.polygon = Reptile.cells_to_polygon(self, cells, {padding=6})
	var area = Area2D.new()
	area.name = "PitDetector"
	if "position" in pit_detector_parent:
		area.position -= pit_detector_parent.position

	(func():
		pit_detector_parent.add_child(area)
		if add_areas_to_owner:
			area.set_owner(owner)

		area.add_child(coll_polygon)
		if add_areas_to_owner:
			coll_polygon.set_owner(owner)
		area.add_to_group(generated_group, true)

		area.set_collision_layer_value(1, false)
		area.set_collision_layer_value(13, true)
		area.set_collision_mask_value(1, false)
		area.set_collision_mask_value(14, true)

		area.body_entered.connect(on_body_entered)
		area.area_entered.connect(on_area_entered)
		).call_deferred()

###################################################################

func on_body_entered(body):
	if body.has_method("on_pit_entered"):
		body.on_pit_entered()
	if body.get_parent().has_method("on_pit_entered"):
		body.get_parent().on_pit_entered()

func on_area_entered(area):
	if area.has_method("on_pit_entered"):
		area.on_pit_entered()
	if area.get_parent().has_method("on_pit_entered"):
		area.get_parent().on_pit_entered()
