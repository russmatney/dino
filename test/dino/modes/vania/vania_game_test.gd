extends GdUnitTestSuite
class_name VaniaGameTest

## basic startup ################################################

func test_game_start():
	var game = auto_free(VaniaGame.new())
	game.generate_rooms({room_inputs=[
		[RoomInputs.IN_SMALL_ROOM,],
		[RoomInputs.IN_SMALL_ROOM,],
		[RoomInputs.IN_SMALL_ROOM,],
		]})

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(3)

	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)

## add rooms ################################################

func test_game_add_rooms():
	var game = auto_free(VaniaGame.new())
	game.generate_rooms({room_inputs=[
		[RoomInputs.IN_SMALL_ROOM,],
		[RoomInputs.IN_SMALL_ROOM,],
		[RoomInputs.IN_SMALL_ROOM,],
		]})

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(3)

	game.add_new_room(2)

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(5)

	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)


## remove rooms ################################################

func test_game_add_room():
	var game = auto_free(VaniaGame.new())
	game.generate_rooms({room_inputs=[
		[RoomInputs.IN_SMALL_ROOM,],
		[RoomInputs.IN_SMALL_ROOM,],
		[RoomInputs.IN_SMALL_ROOM,],
		]})

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(3)

	game.remove_room(1)

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(2)

	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)
