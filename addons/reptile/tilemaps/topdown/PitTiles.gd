@tool
extends RepTileMap

func _ready():
	ensure_pit_detectors()

## create_pit_detector ##################################################################

var generated_group = "_generated"

func create_pit_detector(cells):
	# create polygon

	# get points, not just cell centers
	var points = cells.map(func(c):
		# assumes square tiles
		var half_tile_size = tile_set.tile_size.x / 2 * Vector2.ONE
		var cell_center = to_global(map_to_local(c))
		return [
			cell_center + half_tile_size,
			cell_center - half_tile_size,
			cell_center + Vector2(-half_tile_size.x, half_tile_size.y),
			cell_center + Vector2(half_tile_size.x, -half_tile_size.y),
			]
		).reduce(func(agg, pts):
			agg.append_array(pts)
			return agg, [])

	# remove points found 4 times (internal points)
	var seen_points = {}
	for p in points:
		if p in seen_points:
			seen_points[p] += 1
		else:
			seen_points[p] = 1
	points = []
	for p in seen_points:
		if seen_points[p] < 4:
			points.append(p)

	# Debug.pr(seen_points)
	# Debug.pr(points)

	# sort cells according to angle to midpoint
	var mid = Util.average(points)
	# TODO not perfect for convex shapes, but close
	points.sort_custom(func (a,b):
		var a_ang = mid.angle_to_point(a)
		var b_ang = mid.angle_to_point(b)
		var diff_ang = abs(a_ang - b_ang)
		if diff_ang <= 0.05:
			return mid.distance_to(a) <= mid.distance_to(b)
		return a_ang >= b_ang)

	var polygon = PackedVector2Array()
	for p in points:
		polygon.append(p)

	var coll_polygon = CollisionPolygon2D.new()
	coll_polygon.polygon = polygon
	var area = Area2D.new()

	(func():
		owner.add_child(area)
		area.set_owner(owner)

		area.add_child(coll_polygon)
		coll_polygon.set_owner(owner)
		area.add_to_group(generated_group, true)

		area.set_collision_layer_value(13, true)
		area.set_collision_mask_value(2, true)
		# TODO add other masks

		area.body_entered.connect(on_body_entered)
		area.body_exited.connect(on_body_exited)

		).call_deferred()

###################################################################
# ensure_pit_detectors

func ensure_pit_detectors():
	Debug.pr("ensuring pit detectors")

	for c in owner.get_children():
		if c.is_in_group(generated_group):
			c.queue_free()

	for cells in Reptile.cell_clusters(self):
		create_pit_detector(cells)

###################################################################

func on_body_entered(body):
	Debug.pr("body entered!")
	if "is_player" in body and body.is_player:
		body.machine.transit("Fall")

func on_body_exited(_body):
	Debug.pr("body exited!")
