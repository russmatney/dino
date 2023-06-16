@tool
extends RepTileMap

var generated_group = "_generated"

## ready ##################################################################

func _ready():
	ensure_pit_detectors()

## ensure_pit_detectors ##################################################################

func ensure_pit_detectors():
	Util.free_children_in_group(owner, generated_group)

	for cells in Reptile.cell_clusters(self):
		create_pit_detector(cells)

## create_pit_detector ##################################################################

func create_pit_detector(cells):
	var coll_polygon = CollisionPolygon2D.new()
	coll_polygon.name = "CollisionPolygon2D"
	coll_polygon.polygon = Reptile.cells_to_polygon(self, cells)
	var area = Area2D.new()
	area.name = "PitDetector"

	(func():
		owner.add_child(area)
		area.set_owner(owner)

		area.add_child(coll_polygon)
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
