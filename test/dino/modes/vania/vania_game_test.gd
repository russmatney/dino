extends GdUnitTestSuite
class_name VaniaGameTest

func before():
	Log.set_colors_termsafe()

func before_test():
	VaniaGenerator.remove_generated_cells()
	MetSys.reset_state()
	MetSys.set_save_data()

func after():
	VaniaGenerator.remove_generated_cells()
	MetSys.reset_state()
	MetSys.set_save_data()

## basic startup ################################################

func test_game_start():
	var game = auto_free(VaniaGame.new())
	game.generate_rooms({map_def=MapDef.new({rooms=[
		MapInput.small_room_shape(),
		MapInput.small_room_shape(),
		MapInput.small_room_shape(),
		]})})

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(3)

	await Engine.get_main_loop().process_frame
	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)

## add rooms ################################################

func test_game_add_rooms():
	var game = auto_free(VaniaGame.new())
	game.generate_rooms({map_def=MapDef.new({rooms=[
		MapInput.small_room_shape(),
		MapInput.small_room_shape(),
		MapInput.small_room_shape(),
		]})})

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(3)

	game.add_new_room(2)

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(5)

	await Engine.get_main_loop().process_frame
	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)

## remove rooms ################################################

func test_game_remove_room():
	var game = auto_free(VaniaGame.new())
	game.generate_rooms({map_def=MapDef.new({rooms=[
		MapInput.small_room_shape(),
		MapInput.small_room_shape(),
		MapInput.small_room_shape(),
		]})})

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(3)

	game.remove_room(1)

	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(2)

	await Engine.get_main_loop().process_frame
	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)
