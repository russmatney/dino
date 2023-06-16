@tool
extends RepTileMap

var generated_group = "_generated"

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

		area.set_collision_layer_value(13, true)
		area.set_collision_mask_value(2, true)
		# TODO add other masks (enemy, npc, barrels/boxes)

		area.body_entered.connect(on_body_entered)
		area.body_exited.connect(on_body_exited)
		).call_deferred()

###################################################################

func on_body_entered(body):
	Debug.pr("body entered!")
	if "is_player" in body and body.is_player:
		body.machine.transit("Fall")

func on_body_exited(_body):
	Debug.pr("body exited!")
