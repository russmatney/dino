extends GdUnitTestSuite
class_name VaniaGeneratorTest

func before_test():
	VaniaGenerator.remove_generated_cells()
	MetSys.reset_state()
	MetSys.set_save_data()

## add room ################################################

func test_add_rooms_first_room_small():
	var defs = VaniaRoomDef.generate_defs({room_inputs=[[RoomInputs.IN_SMALL_ROOM,]]})
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var added_def = gened_defs[0]

	assert_str(added_def.room_path).is_not_null()
	assert_array(added_def.map_cells).is_not_empty()
	assert_array(added_def.map_cells).contains([Vector3i()])

func test_add_rooms_first_room_large():
	var defs = VaniaRoomDef.generate_defs({room_inputs=[[RoomInputs.IN_LARGE_ROOM,]]})
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var added_def = gened_defs[0]

	assert_str(added_def.room_path).is_not_null()
	assert_array(added_def.map_cells).is_not_empty()
	assert_array(added_def.map_cells).contains([
		Vector3i(), Vector3i(0, 1, 0),
		Vector3i(1, 0, 0), Vector3i(1, 1, 0),
		])

func test_add_rooms_two_small():
	var defs = VaniaRoomDef.generate_defs({room_inputs=[
		[RoomInputs.IN_SMALL_ROOM,], [RoomInputs.IN_SMALL_ROOM,],]})
	var gen = VaniaGenerator.new()
	var gened_defs = gen.add_rooms(defs)
	var first_room = gened_defs[0]
	var second_room = gened_defs[1]

	assert_str(first_room.room_path).is_not_null()
	assert_array(first_room.map_cells).is_not_empty()
	assert_array(first_room.map_cells).contains([Vector3i()])

	assert_str(second_room.room_path).is_not_null()
	assert_array(second_room.map_cells).is_not_empty()
	assert_array(second_room.map_cells)
