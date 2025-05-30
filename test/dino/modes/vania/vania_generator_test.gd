extends GdUnitTestSuite
class_name VaniaGeneratorTest

func before():
	Log.set_colors_termsafe()

func before_test():
	VaniaGenerator.remove_generated_cells()
	MetSys.reset_state()
	MetSys.set_save_data()

## add/remove rooms ################################################

func test_add_rooms_first_room_small():
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([MapInput.small_room_shape()]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var added_def = gened_defs[0]

	assert_str(added_def.room_path).is_not_null()
	assert_array(added_def.map_cells).is_not_empty()
	assert_array(added_def.map_cells).contains([Vector3i()])

func test_add_rooms_first_room_large():
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([MapInput.large_room_shape()]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var added_def = gened_defs[0]

	assert_str(added_def.room_path).is_not_null()
	assert_array(added_def.map_cells).is_not_empty()
	assert_array(added_def.map_cells).contains([
		Vector3i(), Vector3i(0, 1, 0),
		Vector3i(1, 0, 0), Vector3i(1, 1, 0),
		])

func test_add_rooms_two_small_rooms_create_doors():
	# test creating two rooms at once adds doors between them
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([
		MapInput.small_room_shape(), MapInput.small_room_shape()]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var first_def = gened_defs[0]
	var second_def = gened_defs[1]

	assert_str(first_def.room_path).is_not_null()
	assert_array(first_def.map_cells).is_not_empty()
	assert_array(first_def.map_cells).contains([Vector3i()])

	assert_str(second_def.room_path).is_not_null()
	assert_array(second_def.map_cells).is_not_empty()
	assert_array(second_def.map_cells)

	# test built tilemaps for doors

	for def in [first_def, second_def]:
		var room = load(def.room_path).instantiate()
		room.set_room_def(def)
		var map_cell_rect = def.get_map_cell_rect(def.map_cells[0])
		var tmap = room.get_node("TileMap")
		var cells_rect = Reptile.rect_to_local_rect(tmap, map_cell_rect)
		var tmap_cells = tmap.get_used_cells()

		# expected corners are filled
		assert_array(tmap_cells).contains([cells_rect.position,
			cells_rect.end - Vector2i.ONE,
			cells_rect.position + cells_rect.size * Vector2i.RIGHT + Vector2i.LEFT,
			cells_rect.position + cells_rect.size * Vector2i.DOWN + Vector2i.UP,
			])

		var top_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.position.y))
		var bottom_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.end.y - 1))
		var left_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.position.x, y))
		var right_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.end.x - 1, y))

		assert_array(def.doors).is_not_empty()
		if def.doors.is_empty():
			return

		var door = def.doors[0]
		var wall = door[1] - door[0]

		var door_wall = []
		var other_wall = []
		match Vector2i(wall.x, wall.y):
			Vector2i.LEFT:
				door_wall = left_border
				other_wall = right_border
				assert_array(tmap_cells).contains(top_border)
				assert_array(tmap_cells).contains(right_border)
				assert_array(tmap_cells).contains(bottom_border)
			Vector2i.UP:
				door_wall = top_border
				other_wall = bottom_border
				assert_array(tmap_cells).contains(left_border)
				assert_array(tmap_cells).contains(right_border)
				assert_array(tmap_cells).contains(bottom_border)
			Vector2i.RIGHT:
				door_wall = right_border
				other_wall = left_border
				assert_array(tmap_cells).contains(left_border)
				assert_array(tmap_cells).contains(top_border)
				assert_array(tmap_cells).contains(bottom_border)
			Vector2i.DOWN:
				door_wall = bottom_border
				other_wall = top_border
				assert_array(tmap_cells).contains(left_border)
				assert_array(tmap_cells).contains(top_border)
				assert_array(tmap_cells).contains(right_border)
			_:
				assert_that(true).is_equal(false)

		door_wall = door_wall.filter(func(cell): return cell in tmap_cells)
		other_wall = other_wall.filter(func(cell): return cell in tmap_cells)
		assert_array(door_wall).is_not_empty()
		assert_int(len(other_wall)).is_greater(len(door_wall))

func test_add_rooms_one_small_room_then_another_updates_doors():
	# test creating two rooms in separate gen.add_rooms() calls updates the first room's doors
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([MapInput.small_room_shape()]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var first_def = gened_defs[0]

	defs = VaniaRoomDef.to_defs(MapDef.with_inputs([MapInput.small_room_shape()]))
	gened_defs = gen.add_rooms(defs)
	var second_def = gened_defs[1]

	assert_str(first_def.room_path).is_not_null()
	assert_array(first_def.map_cells).is_not_empty()
	assert_array(first_def.map_cells).contains([Vector3i()])

	assert_str(second_def.room_path).is_not_null()
	assert_array(second_def.map_cells).is_not_empty()
	assert_array(second_def.map_cells)

	# test built tilemaps for doors

	for def in [first_def, second_def]:
		var room = load(def.room_path).instantiate()
		room.set_room_def(def)
		var map_cell_rect = def.get_map_cell_rect(def.map_cells[0])
		var tmap = room.get_node("TileMap")
		var cells_rect = Reptile.rect_to_local_rect(tmap, map_cell_rect)
		var tmap_cells = tmap.get_used_cells()

		# expected corners are filled
		assert_array(tmap_cells).contains([cells_rect.position,
			cells_rect.end - Vector2i.ONE,
			cells_rect.position + cells_rect.size * Vector2i.RIGHT + Vector2i.LEFT,
			cells_rect.position + cells_rect.size * Vector2i.DOWN + Vector2i.UP,
			])

		var top_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.position.y))
		var bottom_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.end.y - 1))
		var left_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.position.x, y))
		var right_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.end.x - 1, y))

		assert_array(def.doors).is_not_empty()
		if def.doors.is_empty():
			return

		var door = def.doors[0]
		var wall = door[1] - door[0]

		var door_wall = []
		var other_wall = []
		match Vector2i(wall.x, wall.y):
			Vector2i.LEFT:
				door_wall = left_border
				other_wall = right_border
				assert_array(tmap_cells).contains(top_border)
				assert_array(tmap_cells).contains(right_border)
				assert_array(tmap_cells).contains(bottom_border)
			Vector2i.UP:
				door_wall = top_border
				other_wall = bottom_border
				assert_array(tmap_cells).contains(left_border)
				assert_array(tmap_cells).contains(right_border)
				assert_array(tmap_cells).contains(bottom_border)
			Vector2i.RIGHT:
				door_wall = right_border
				other_wall = left_border
				assert_array(tmap_cells).contains(left_border)
				assert_array(tmap_cells).contains(top_border)
				assert_array(tmap_cells).contains(bottom_border)
			Vector2i.DOWN:
				door_wall = bottom_border
				other_wall = top_border
				assert_array(tmap_cells).contains(left_border)
				assert_array(tmap_cells).contains(top_border)
				assert_array(tmap_cells).contains(right_border)
			_:
				assert_that(true).is_equal(false)

		door_wall = door_wall.filter(func(cell): return cell in tmap_cells)
		other_wall = other_wall.filter(func(cell): return cell in tmap_cells)
		assert_array(door_wall).is_not_empty()
		assert_int(len(other_wall)).is_greater(len(door_wall))


func test_add_rooms_two_small_rooms_remove_one_removes_doors():
	# test that removing a room updates the left-behind room's doors
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([
		MapInput.small_room_shape(), MapInput.small_room_shape()
		]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	gen.remove_rooms([defs[1]]) # remove the second room
	var def = gened_defs[0]

	assert_str(def.room_path).is_not_null()
	assert_array(def.map_cells).is_not_empty()
	assert_array(def.map_cells).contains([Vector3i()])

	# test built tilemaps for doors

	var room = load(def.room_path).instantiate()
	room.set_room_def(def)
	var map_cell_rect = def.get_map_cell_rect(def.map_cells[0])
	var tmap = room.get_node("TileMap")
	var cells_rect = Reptile.rect_to_local_rect(tmap, map_cell_rect)
	var tmap_cells = tmap.get_used_cells()

	# expected corners are filled
	assert_array(tmap_cells).contains([cells_rect.position,
		cells_rect.end - Vector2i.ONE,
		cells_rect.position + cells_rect.size * Vector2i.RIGHT + Vector2i.LEFT,
		cells_rect.position + cells_rect.size * Vector2i.DOWN + Vector2i.UP,
		])

	var top_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.position.y))
	var bottom_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.end.y - 1))
	var left_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.position.x, y))
	var right_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.end.x - 1, y))

	assert_array(tmap_cells).contains(left_border)
	assert_array(tmap_cells).contains(top_border)
	assert_array(tmap_cells).contains(right_border)
	assert_array(tmap_cells).contains(bottom_border)

## consistent minimal doors

func test_add_rooms_consistent_doors():
	# creating two tall rooms with minimal-horizontal doors
	var map_def = MapDef.with_inputs([
		MapInput.has_room({shape=RoomShape.new({type=RoomShape.T.TALL_5})}),
		MapInput.has_room({shape=RoomShape.new({type=RoomShape.T.TALL_5})}),
		])
	map_def.input.door_mode = VaniaRoomDef.DOOR_MODE.MINIMAL_HORIZONTAL

	var gen = VaniaGenerator.new()
	var defs = gen.generate_map(map_def)
	var first_def = defs[0]
	var second_def = defs[1]

	await Engine.get_main_loop().process_frame

	assert_str(first_def.room_path).is_not_null()
	assert_array(first_def.map_cells).is_not_empty()

	assert_str(second_def.room_path).is_not_null()
	assert_array(second_def.map_cells).is_not_empty()

	var first_doors = first_def.doors
	var second_doors = second_def.doors
	assert_array(first_doors).is_not_empty()
	assert_array(second_doors).is_not_empty()
	assert_int(len(first_doors)).is_equal(1)
	assert_int(len(second_doors)).is_equal(1)

	var first_door = first_doors[0]
	var second_door = second_doors[0]

	assert_array(first_door).contains_exactly_in_any_order(second_door)

func test_add_rooms_consistent_doors_three_rooms():
	# creating two tall rooms with minimal-horizontal doors
	var map_def = MapDef.with_inputs([
		MapInput.has_room({shape=RoomShape.new({type=RoomShape.T.TALL_5})}),
		MapInput.has_room({shape=RoomShape.new({type=RoomShape.T.TALL_5})}),
		MapInput.has_room({shape=RoomShape.new({type=RoomShape.T.TALL_5})}),
		])
	map_def.input.door_mode = VaniaRoomDef.DOOR_MODE.MINIMAL_HORIZONTAL
	map_def.input.neighbor_direction = Vector2i.RIGHT

	var gen = VaniaGenerator.new()
	var defs = gen.generate_map(map_def)
	var first_def = defs[0]
	var second_def = defs[1]
	var third_def = defs[2]

	await Engine.get_main_loop().process_frame

	assert_str(first_def.room_path).is_not_null()
	assert_array(first_def.map_cells).is_not_empty()
	assert_str(second_def.room_path).is_not_null()
	assert_array(second_def.map_cells).is_not_empty()
	assert_str(third_def.room_path).is_not_null()
	assert_array(third_def.map_cells).is_not_empty()

	var first_doors = first_def.doors
	var second_doors = second_def.doors
	var third_doors = third_def.doors

	assert_array(first_doors).is_not_empty()
	assert_array(second_doors).is_not_empty()
	assert_array(third_doors).is_not_empty()

	# TODO restore this test when we control room placement more
	# there are cases where these rooms find a way to stack vertically...
	# var more
	# var other_a
	# var other_b

	# if len(first_doors) == 2:
	# 	more = first_doors
	# 	other_a = second_doors
	# 	other_b = third_doors
	# elif len(second_doors) == 2:
	# 	more = second_doors
	# 	other_a = first_doors
	# 	other_b = third_doors
	# elif len(third_doors) == 2:
	# 	more = third_doors
	# 	other_a = second_doors
	# 	other_b = first_doors

	# assert_int(len(more)).is_equal(2)
	# assert_int(len(other_a)).is_equal(1)
	# assert_int(len(other_b)).is_equal(1)

	# assert_array(more).contains([U.reverse(other_a[0])])
	# assert_array(more).contains([U.reverse(other_b[0])])


## placing rooms ################################################

func test_possible_start_coords_simple():
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([MapInput.small_room_shape()]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var def = gened_defs[0]

	var map_cells = VaniaGenerator.get_existing_map_cells()
	var possible = gen.get_possible_start_coords(map_cells, def)

	assert_array(possible).is_not_empty()
	assert_array(possible).contains([
		Vector3i(0, 1, 0),
		Vector3i(1, 0, 0),
		Vector3i(0, -1, 0),
		Vector3i(-1, 0, 0),
		])

func test_possible_start_coords_concave():
	var defs = VaniaRoomDef.to_defs(MapDef.with_inputs([MapInput.small_room_shape()]))
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var def = gened_defs[0]

	def.set_local_cells([
		Vector3i(0, 0, 0), Vector3i(0, 1, 0),
		Vector3i(1, 0, 0),
		])
	var map_cells = VaniaGenerator.get_existing_map_cells()
	var possible = gen.get_possible_start_coords(map_cells, def)

	assert_array(possible).is_not_empty()
	assert_array(possible).contains([
		Vector3i(-2, 0, 0), Vector3i(-1, -1, 0), Vector3i(-1, 1, 0), Vector3i(0, -2, 0), Vector3i(0, 1, 0), Vector3i(1, -1, 0), Vector3i(1, 0, 0)
		])
