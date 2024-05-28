extends GdUnitTestSuite
class_name VaniaThreadsTest

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

## basic threaded game generation ################################################

func test_threaded_game_gen():
	var room_count = 5
	var inputs = []
	for i in range(room_count):
		inputs.append(MapInput.small_room_shape().merge(MapInput.coldfire_tiles()))
	var map_def = MapDef.new({rooms=inputs})
	var game = auto_free(VaniaGame.create_game_node(map_def))

	# adding game to tree should kick off generation
	add_child(game)

	# wait for generation to finish
	await game.room_gen_complete

	# basic room_def assertions
	assert_array(game.room_defs).is_not_empty()
	assert_int(len(game.room_defs)).is_equal(room_count)
	for def in game.room_defs:
		var cells = MetSys.map_data.get_cells_assigned_to(def.room_path)
		assert_array(cells).is_not_empty()
		assert_array(cells).is_equal(def.map_cells)

## interrupted thread generation ################################################

func test_threaded_game_gen_interrupted():
	var room_count = 5
	var inputs = []
	for i in range(room_count):
		inputs.append(MapInput.small_room_shape().merge(MapInput.coldfire_tiles()))
	var map_def = MapDef.new({rooms=inputs})
	var game = VaniaGame.create_game_node(map_def)

	game.ready.connect(func():
		# wait a bit
		await Engine.get_main_loop().process_frame
		await Engine.get_main_loop().process_frame
		await Engine.get_main_loop().process_frame
		await Engine.get_main_loop().process_frame
		await Engine.get_main_loop().process_frame
		# remove child and don't crash
		remove_child(game))

	# adding game to tree should kick off generation
	add_child.call_deferred(game)

	# this test should fail if the thread is not cleaned up properly
	# (when errors occur, gdunit marks tests as failed)

	await game.ready
	assert_that(true).is_true()

	# wait for node exit so we catch all the errors
	await game.tree_exited
	assert_that(true).is_true()
