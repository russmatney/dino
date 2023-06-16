@tool
extends RepTileMap

var generated_group = "_generated"

## ready ##################################################################

func _ready():
	ensure_pit_detectors()

## physics_process ##################################################################

func _physics_process(_delta):
	for b_name in bodies:
		Debug.pr("checking b_name", b_name)
		var area = bodies[b_name].area
		var body = bodies[b_name].body

		if body.has_method("on_entered_pit"):
			# TODO write an area2d.encloses(body) helper
			# https://ask.godotengine.org/38351/check-if-area2d-fully-encloses-physicsbody2d
			# this is garbo
			# var body_shape = body.get_node('CollisionShape2D').shape
			# var area_shape = area.get_node('CollisionPolygon2D').shape
			# var body_rect = body_shape.get_rect()
			# var area_rect = area_shape.get_rect()
			# if area.overlaps_body(body):

			body.on_entered_pit()
			# remove from local map bodies
			bodies.erase(body.name)

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
		area.set_collision_mask_value(1, false)
		area.set_collision_mask_value(2, true)
		area.set_collision_mask_value(4, true)
		area.set_collision_mask_value(10, true)

		area.body_entered.connect(on_body_entered.bind(area))
		area.body_exited.connect(on_body_exited.bind(area))
		).call_deferred()

###################################################################

var bodies = {}

# all bodies are tracked, filtering is based on collision layer
func on_body_entered(body, area):
	if not body.name in bodies:
		bodies[body.name] = {area=area, body=body}

	if body.has_method("on_pit_touched"):
		body.on_pit_touched()

func on_body_exited(body, _area):
	bodies.erase(body.name)
