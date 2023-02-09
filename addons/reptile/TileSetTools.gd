@tool
extends TileSet

@export var dryrun: bool = true
@export var tile_name: String = "somedefault"

### ready #####################################################################


func _ready():
	print("tileSet tool script ready")


func _enter_tree():
	print("tileSet Tool enter tree")


func _exit_tree():
	print("tileSet Tool exit tree")


### helpers #####################################################################


func tiles_with_name(name):
	var used_tile_ids = get_tiles_ids()
	var tile_ids = []
	for t_id in used_tile_ids:
		if name == tile_get_name(t_id):
			tile_ids.append(t_id)
	return tile_ids


### generate_collisions #######################################################

@export var run_gen_collisions: bool = false : set = run_gen_colls


func run_gen_colls(val):
	if val:
		gen_collisions(tiles_with_name(tile_name))


func gen_collisions(tile_ids):
	print("generating collisions for tile_ids: ", tile_ids)

	for t_id in tile_ids:
		var mode = tile_get_tile_mode(t_id)
		match mode:
			1:
				gen_collisions_for_atlas(t_id)
			2:
				gen_collisions_for_atlas(t_id)
			_:
				print("unsupported tile mode: ", mode, " for tile: ", t_id)


func gen_collisions_for_atlas(tile_id):
	var region_rect = tile_get_region(tile_id)
	var tile_size = autotile_get_size(tile_id).x

	print("tile_size, region_rect.size", tile_size, region_rect.size)

	var end_point_x = int(region_rect.size.x) / int(tile_size)  # seems legit?
	var end_point_y = int(region_rect.size.y) / int(tile_size)

	print("end point x,y", end_point_x, end_point_y)

	for x in range(0, end_point_x):
		for y in range(0, end_point_y):
			# this value is local to the atlas
			var autotile_coord = Vector2(x, y)
			var shape = create_collision_shape(tile_id)
			if dryrun:
				print(
					"would add collision shape to tile_id: ", tile_id, " at coord: ", autotile_coord
				)
			else:
				print("adding collision shape to tile_id: ", tile_id, " at coord: ", autotile_coord)
				tile_add_shape(tile_id, shape, Transform2D(0, Vector2.ZERO), false, autotile_coord)


func create_collision_shape(tile_id):
	var tile_size = autotile_get_size(tile_id).x
	var shape = ConvexPolygonShape2D.new()
	shape.points = [
		Vector2(0, 0), Vector2(0, tile_size), Vector2(tile_size, tile_size), Vector2(tile_size, 0)
	]
	return shape


### clean_collisions #######################################################

@export var run_clean_collisions: bool = false : set = run_clean_colls


func run_clean_colls(val):
	if val:
		clean_collisions(tiles_with_name(tile_name))


func clean_collisions(tile_ids):
	print("cleaning collision shapes for tile_ids: ", tile_ids)

	for t_id in tile_ids:
		var mode = tile_get_tile_mode(t_id)
		match mode:
			1:
				clean_collisions_for_auto_tiles(t_id)
			_:
				print("unsupported tile mode: ", mode, " for tile: ", t_id)


func clean_collisions_for_auto_tiles(tile_id):
	var tile_shape_dicts = tile_get_shapes(tile_id)
	for d in tile_shape_dicts:
		print("shape", d["shape"], d["shape"].points)
		var points = d["shape"].points
		var cleaned_points = []
		for p in points:
			var x = round(p.x)
			var y = round(p.y)
			var cleaned_vec = Vector2(x, y)
			cleaned_points.append(cleaned_vec)

		if not dryrun:
			d["shape"].points = cleaned_points
		print("cleaned shape", d["shape"], d["shape"].points)


### copy_collisions_to_occluders #######################################################

@export var run_copy_colls_to_occs: bool = false : set = run_copy_colls_occs


func run_copy_colls_occs(val):
	if val:
		copy_collisions_to_occluders(tiles_with_name(tile_name))


func copy_collisions_to_occluders(tile_ids):
	print("copying collision shapes into occluder shapes for tile_ids: ", tile_ids)

	for t_id in tile_ids:
		var mode = tile_get_tile_mode(t_id)
		match mode:
			1:
				copy_collisions_to_occluders_for_auto_tiles(t_id)
			_:
				print("unsupported tile mode: ", mode, " for tile: ", t_id)


func copy_collisions_to_occluders_for_auto_tiles(tile_id):
	var tile_shape_dicts = tile_get_shapes(tile_id)
	for d in tile_shape_dicts:
		var autotile_coord = d["autotile_coord"]

		var existing_occluder = autotile_get_light_occluder(tile_id, autotile_coord)

		if existing_occluder:
			print("skipping overwrite of existing occluder! ", tile_id, " ", autotile_coord)
			continue

		# TODO bug - this only copies one collision shape per coord!
		var new_occluder = OccluderPolygon2D.new()
		new_occluder.polygon = d["shape"].points
		print("new occluder: ", new_occluder.polygon, " for shape: ", d["shape"].points)
		if not dryrun:
			autotile_set_light_occluder(tile_id, new_occluder, autotile_coord)
