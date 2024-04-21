extends GdUnitTestSuite
class_name VaniaRoomInputsTest

func before():
	Log.set_colors_termsafe()

## empty state ###########################################################

func test_room_inputs_empty_inputs_behavior():
	var inp = RoomInputs.new()
	assert_array(inp.tilemap_scenes).is_empty()
	assert_array(inp.entities).is_empty()
	assert_array(inp.room_shape).is_empty()
	assert_array(inp.room_shapes).is_empty()

	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(def.tilemap_scenes).is_not_empty()
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.entities).is_empty()
	assert_array(def.constraints).is_empty()

## entities ######################################################

func test_room_inputs_set_entities():
	var some_ents = [
		Pandora.get_entity(DinoEntityIds.PLAYERSPAWNPOINT),
		Pandora.get_entity(DinoEntityIds.CANDLE),
		]
	var inp = RoomInputs.new({entities=some_ents})
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.entities).is_not_empty()
	assert_array(def.entities).is_not_empty()
	assert_array(def.entities).contains(some_ents)

func test_room_inputs_combine_entities():
	# entities should combine and keep dupes

	var some_ents = [
		Pandora.get_entity(DinoEntityIds.PLAYERSPAWNPOINT),
		Pandora.get_entity(DinoEntityIds.CANDLE),
		]
	var inp_1 = RoomInputs.new({entities=some_ents})
	var some_more_ents = [
		Pandora.get_entity(DinoEntityIds.BOX),
		Pandora.get_entity(DinoEntityIds.CANDLE),
		]
	var inp_2 = RoomInputs.new({entities=some_more_ents})

	var inp = inp_1.merge(inp_2)

	assert_array(inp.entities).is_not_empty()
	assert_array(inp.entities).contains(some_ents)
	assert_array(inp.entities).contains(some_more_ents)
	assert_int(len(inp.entities)).is_equal(4)

	var def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(def.entities).is_not_empty()
	assert_array(def.entities).contains(some_ents)
	assert_array(def.entities).contains(some_more_ents)
	assert_int(len(def.entities)).is_equal(4)

## tilemaps ######################################################

func test_room_inputs_set_tilemaps():
	var some_scene = load("res://addons/core/reptile/tilemaps/VolcanoTiles8.tscn")
	var inp = RoomInputs.new({tilemap_scenes=[some_scene]})
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(def.tilemap_scenes).contains([some_scene])

func test_room_inputs_combine_tilemaps():
	# tilemaps should combine but remain distinct (no dupes!)

	var vol_tile = load("res://addons/core/reptile/tilemaps/VolcanoTiles8.tscn")
	var grass_tile = load("res://addons/core/reptile/tilemaps/GrassyCaveTileMap8.tscn")
	var gold_tile = load("res://addons/core/reptile/tilemaps/GildedKingdomTiles8.tscn")
	var some_tilemaps = [vol_tile, grass_tile]
	var some_overlapping_tilemaps = [vol_tile, gold_tile]
	var inp_1 = RoomInputs.new({tilemap_scenes=some_tilemaps})
	var inp_2 = RoomInputs.new({tilemap_scenes=some_overlapping_tilemaps})
	var inp = RoomInputs.merge_many([inp_1, inp_2])

	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).contains(some_tilemaps)
	assert_array(inp.tilemap_scenes).contains(some_overlapping_tilemaps)
	assert_int(len(inp.tilemap_scenes)).is_equal(3)
	assert_array(def.tilemap_scenes).contains(some_tilemaps)
	assert_array(def.tilemap_scenes).contains(some_overlapping_tilemaps)
	assert_int(len(def.tilemap_scenes)).is_equal(3)


## room_shapes ######################################################

func test_room_inputs_room_shapes_set_local_cells():
	var some_shape = [Vector3i(0, 0, 0), Vector3i(1, 0, 0)]
	var inp = RoomInputs.new({room_shapes=[some_shape]})
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.room_shapes).is_not_null()
	assert_array(inp.room_shapes).is_not_empty()
	assert_array(def.local_cells).is_equal(some_shape)

func test_room_inputs_room_shapes_combine_before_selection():
	# 'room_shapes' combine without dupes, but only one is set as local_cells

	var some_shape = [Vector3i(0, 0, 0), Vector3i(1, 0, 0)]
	var some_other_shape = [Vector3i(0, 0, 0)]
	var inp1 = RoomInputs.new({room_shapes=[some_shape]})
	var inp2 = RoomInputs.new({room_shapes=[some_other_shape, some_shape]})
	var inp = inp1.merge(inp2)

	assert_array(inp.room_shapes).is_not_empty()
	assert_array(inp.room_shapes).contains([some_shape, some_other_shape])
	assert_int(len(inp.room_shapes)).is_equal(2)

	var def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(inp.room_shapes).contains([def.local_cells])

func test_room_inputs_room_shape_always_overwrites_room_shapes():
	# if `room_shape` is set, it is used instead of random from 'room_shapes'
	var some_shapes = [[Vector3i(0, 0, 0), Vector3i(1, 0, 0)], [Vector3i(0, 0, 0), Vector3i(0, 1, 0)],]
	var some_other_shape = [Vector3i(0, 0, 0)]
	var inp1 = RoomInputs.new({room_shapes=some_shapes})
	var inp2 = RoomInputs.new({room_shape=some_other_shape})
	var inp = inp1.merge(inp2)

	assert_array(inp.room_shapes).is_not_empty()
	assert_array(inp.room_shapes).contains(some_shapes)
	assert_int(len(inp.room_shapes)).is_equal(2)
	assert_array(inp.room_shape).is_equal(some_other_shape)

	var def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(def.local_cells).is_equal(some_other_shape)

	# merging in the other direction - the existing 'room_shape' is still used even tho 'room_shapes' are added
	inp = inp2.merge(inp1)
	def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(def.local_cells).is_equal(some_other_shape)

	# now merging with a set 'room_shape' - the passed input overwrites 'room_shape'
	var some_third_shape = [Vector3i(0, 0, 0), Vector3i(1, 0, 0), Vector3i(2, 0, 0)]
	inp1.room_shape.assign(some_third_shape)
	inp = inp2.merge(inp1)
	def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(def.local_cells).is_equal(some_third_shape)


## higher level api ######################################################

func test_room_def_inputs_spaceship_sets_tilemap():
	# spaceship sets a tileset as expected
	var def = VaniaRoomDef.new()
	var inp = RoomInputs.apply_constraints([RoomInputs.IN_SPACESHIP], def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(def.tilemap_scenes).is_not_empty()
	assert_array(def.tilemap_scenes).contains(inp.tilemap_scenes)
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.entities).is_empty()
	assert_array(def.constraints).is_not_empty()
	assert_array(def.constraints).contains([RoomInputs.IN_SPACESHIP])

func test_room_def_inputs_player_room_sets_entities_and_shape():
	var def = VaniaRoomDef.new()
	var inp = RoomInputs.apply_constraints([
		RoomInputs.HAS_PLAYER,
		RoomInputs.IN_SPACESHIP,
		RoomInputs.IN_SMALL_ROOM,
		], def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(def.tilemap_scenes).contains(inp.tilemap_scenes)
	assert_array(def.tilemap_scenes).is_not_empty()

	assert_that(inp.room_shape).is_not_null()
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.local_cells).is_equal(inp.room_shape)

	assert_array(inp.entities).is_not_empty()
	assert_array(def.entities).is_not_empty()
	assert_that(inp.entities[0].get_entity_id()).is_equal(DinoEntityIds.PLAYERSPAWNPOINT)
	assert_that(def.entities[0].get_entity_id()).is_equal(DinoEntityIds.PLAYERSPAWNPOINT)

func test_room_def_inputs_leaf_and_kingdom_have_fallback_room_shape():
	var def = VaniaRoomDef.new()
	var inp = RoomInputs.apply_constraints([
		RoomInputs.HAS_LEAF,
		RoomInputs.IN_KINGDOM,
		], def)

	assert_array(inp.tilemap_scenes).is_not_null()
	assert_array(inp.tilemap_scenes).is_not_empty()
	assert_array(def.tilemap_scenes).contains(inp.tilemap_scenes)

	assert_array(inp.entities).is_not_empty()
	assert_array(def.entities).is_not_empty()
	assert_that(inp.entities[0].get_entity_id()).is_equal(DinoEntityIds.LEAF)
	assert_that(def.entities[0].get_entity_id()).is_equal(DinoEntityIds.LEAF)

	# room shapes input is empty, but the def's local_cells is not!
	assert_array(inp.room_shapes).is_empty()
	assert_array(def.local_cells).is_not_empty()
	# local_cells is set by all_room_shapes static var
	# shape lib isn't normalized but local_cells is
	# assert_array(inp.all_room_shapes.values()).contains([def.local_cells])

## constraints ######################################################

func test_apply_constraints_keeps_local_cells():
	var def = VaniaRoomDef.new()
	var _inp = RoomInputs.apply_constraints([
		RoomInputs.IN_SMALL_ROOM,
		], def)

	assert_array(def.local_cells).is_equal(RoomInputs.all_room_shapes.small)

	var my_local_cells = [Vector3i(0, 0, 0)]
	def = VaniaRoomDef.new({local_cells=my_local_cells})
	_inp = RoomInputs.apply_constraints([RoomInputs.IN_LARGE_ROOM,], def)

	assert_array(def.local_cells).is_equal(my_local_cells)

func test_apply_constraints_appends_multiple_entities():
	var def = VaniaRoomDef.new()
	var inp = RoomInputs.apply_constraints([
			RoomInputs.HAS_TARGET,
			RoomInputs.HAS_TARGET,
			RoomInputs.HAS_PLAYER,
			], def)

	assert_int(len(inp.entities)).is_equal(3)
	assert_int(len(def.entities)).is_equal(3)
	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])

func test_apply_constraints_supports_dicts_and_opts():
	var def = VaniaRoomDef.new()
	# pass just a dict
	var inp = RoomInputs.apply_constraints({
			RoomInputs.HAS_TARGET: {count=4},
			RoomInputs.HAS_PLAYER: {}
			}, def)

	assert_int(len(inp.entities)).is_equal(5)
	assert_int(len(def.entities)).is_equal(5)
	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])

	def = VaniaRoomDef.new()
	# pass just an array of dict
	inp = RoomInputs.apply_constraints([{
			RoomInputs.HAS_TARGET: {count=4},
			RoomInputs.HAS_PLAYER: {}
			}], def)

	assert_int(len(inp.entities)).is_equal(5)
	assert_int(len(def.entities)).is_equal(5)
	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])

	def = VaniaRoomDef.new()
	# pass just an array of dicts
	inp = RoomInputs.apply_constraints([{
			RoomInputs.HAS_TARGET: {count=4},
		}, {
			RoomInputs.HAS_PLAYER: {}
		}], def)

	assert_int(len(inp.entities)).is_equal(5)
	assert_int(len(def.entities)).is_equal(5)
	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
