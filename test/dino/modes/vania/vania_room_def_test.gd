extends GdUnitTestSuite
class_name VaniaRoomDefTest

func test_get_size():
	var rd = VaniaRoomDef.new()
	rd.map_cells = [
		Vector3i(0, 0, 0),
		Vector3i(1, 0, 0),
		]
	var s = rd.get_size()
	assert_float(s.x).is_equal(512)
	assert_float(s.y).is_equal(144)

	rd.map_cells = [
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(1, 1, 0),
		]
	rd.calc_cell_meta()
	s = rd.get_size()
	assert_float(s.x).is_equal(512)
	assert_float(s.y).is_equal(288)


func test_room_def_inputs():
	var inp = RoomInputs.spaceship()
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(def.tilemap_scenes).is_not_empty()
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.entities).is_empty()

	inp = RoomInputs.player_room().merge(RoomInputs.spaceship())
	def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(inp.room_shape).is_not_null()

	assert_array(inp.entities).contains(["Player"])
	assert_array(def.tilemap_scenes).is_not_empty()
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.entities).is_not_empty()

	inp = RoomInputs.leaf_room().merge(RoomInputs.kingdom())
	def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(inp.entities).contains(["Leaf"])

	# room shapes input is empty, but the def's local_cells is not!
	assert_array(inp.room_shapes).is_empty()
	assert_array(def.local_cells).is_not_empty()

	assert_array(def.tilemap_scenes).is_not_empty()
	assert_array(def.entities).is_not_empty()
