extends GdUnitTestSuite
class_name VaniaMapInputTest

func before():
	Log.set_colors_termsafe()

## empty state ###########################################################

func test_inputs_empty_inputs_behavior():
	var inp = MapInput.new()
	assert_array(inp.tiles).is_empty()
	assert_array(inp.entities).is_empty()
	assert_array(inp.room_shape).is_null()
	assert_array(inp.room_shapes).is_empty()

	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(def.tiles()).is_not_empty()
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.entities()).is_empty()
	assert_array(def.enemies()).is_empty()
	assert_array(def.effects()).is_empty()

## entities ######################################################

func test_inputs_set_entities():
	var some_ents = [
		Pandora.get_entity(DinoEntityIds.PLAYERSPAWNPOINT),
		Pandora.get_entity(DinoEntityIds.CANDLE),
		]
	var inp = MapInput.new({entities=some_ents})
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.entities).is_not_empty()
	assert_array(def.entities()).is_not_empty()
	assert_array(def.entities()).contains(some_ents)

func test_inputs_combine_entities():
	# entities should combine and keep dupes

	var some_ents = [
		Pandora.get_entity(DinoEntityIds.PLAYERSPAWNPOINT),
		Pandora.get_entity(DinoEntityIds.CANDLE),
		]
	var inp_1 = MapInput.new({entities=some_ents})
	var some_more_ents = [
		Pandora.get_entity(DinoEntityIds.BOX),
		Pandora.get_entity(DinoEntityIds.CANDLE),
		]
	var inp_2 = MapInput.new({entities=some_more_ents})

	var inp = inp_1.merge(inp_2)

	assert_array(inp.entities).is_not_empty()
	assert_array(inp.entities).contains(some_ents)
	assert_array(inp.entities).contains(some_more_ents)
	assert_int(len(inp.entities)).is_equal(4)

	var def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(def.entities()).is_not_empty()
	assert_array(def.entities()).contains(some_ents)
	assert_array(def.entities()).contains(some_more_ents)
	assert_int(len(def.entities())).is_equal(4)

## tilemaps ######################################################

func test_inputs_set_tilemaps():
	var some_tiles = DinoTiles.all_tiles().pick_random()
	var inp = MapInput.new({tiles=[some_tiles]})
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tiles).is_not_null()
	assert_array(inp.tiles).is_not_empty()
	assert_array(def.tiles()).contains([some_tiles])

func test_inputs_combine_tilemaps():
	# tilemaps should combine but remain distinct (no dupes!)

	var vol_tile = Pandora.get_entity(DinoTileIds.VOLCANOTILES)
	var grass_tile = Pandora.get_entity(DinoTileIds.GRASSYCAVETILES)
	var gold_tile = Pandora.get_entity(DinoTileIds.KINGDOMTILES)
	var some_tilemaps = [vol_tile, grass_tile]
	var some_overlapping_tilemaps = [vol_tile, gold_tile]
	var inp_1 = MapInput.new({tiles=some_tilemaps})
	var inp_2 = MapInput.new({tiles=some_overlapping_tilemaps})
	var inp = MapInput.merge_many([inp_1, inp_2])

	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.tiles).is_not_null()
	assert_array(inp.tiles).contains(some_tilemaps)
	assert_array(inp.tiles).contains(some_overlapping_tilemaps)
	assert_int(len(inp.tiles)).is_equal(3)
	assert_array(def.tiles()).contains(some_tilemaps)
	assert_array(def.tiles()).contains(some_overlapping_tilemaps)
	assert_int(len(def.tiles())).is_equal(3)


## room_shapes ######################################################

func test_inputs_room_shapes_set_local_cells():
	var some_shape = [Vector3i(0, 0, 0), Vector3i(1, 0, 0)]
	var inp = MapInput.new({room_shapes=[RoomShape.new({cells=some_shape})]})
	var def = VaniaRoomDef.new()
	inp.update_def(def)

	assert_array(inp.room_shapes).is_not_null()
	assert_array(inp.room_shapes).is_not_empty()
	assert_array(def.local_cells).is_equal(some_shape)

func test_inputs_room_shapes_combine_before_selection():
	# 'room_shapes' combine without dupes, but only one is set as local_cells

	var some_shape = [Vector3i(0, 0, 0), Vector3i(1, 0, 0)]
	var some_other_shape = [Vector3i(0, 0, 0)]
	var inp1 = MapInput.new({room_shapes=[RoomShape.new({cells=some_shape})]})
	var inp2 = MapInput.new({room_shapes=[some_other_shape, some_shape].map(func(cells): return RoomShape.new({cells=cells}))})
	var inp = inp1.merge(inp2)

	assert_array(inp.room_shapes).is_not_empty()
	assert_array(inp.room_shapes.map(func(s): return s.cells)).contains([some_shape, some_other_shape])
	assert_int(len(inp.room_shapes)).is_equal(3) # room_shapes are now unique, they don't dedupe on shape (yet?)

	var def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(inp.room_shapes.map(func(s): return s.cells)).contains([def.local_cells])

func test_inputs_room_shape_always_overwrites_room_shapes():
	# if `room_shape` is set, it is used instead of random from 'room_shapes'
	var some_shapes = [[Vector3i(0, 0, 0), Vector3i(1, 0, 0)], [Vector3i(0, 0, 0), Vector3i(0, 1, 0)],]
	var some_other_shape = [Vector3i(0, 0, 0)]
	var inp1 = MapInput.new({room_shapes=some_shapes.map(func(cells): return RoomShape.new({cells=cells}))})
	var inp2 = MapInput.new({room_shape=RoomShape.new({cells=some_other_shape})})
	var inp = inp1.merge(inp2)

	assert_array(inp.room_shapes).is_not_empty()
	assert_array(inp.room_shapes.map(func(s): return s.cells)).contains(some_shapes)
	assert_int(len(inp.room_shapes)).is_equal(2)
	assert_array(inp.room_shape.cells).is_equal(some_other_shape)

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
	inp1.room_shape = RoomShape.new({cells=some_third_shape})
	inp = inp2.merge(inp1)
	def = VaniaRoomDef.new()
	inp.update_def(def)
	assert_array(def.local_cells).is_equal(some_third_shape)


## higher level api ######################################################

func test_room_def_inputs_spaceship_sets_tilemap():
	# spaceship sets a tileset as expected
	var def = VaniaRoomDef.new()
	var inp = MapInput.apply(MapInput.spaceship(), def)

	assert_array(inp.tiles).is_not_null()
	assert_array(inp.tiles).is_not_empty()
	assert_array(def.tiles()).is_not_empty()
	assert_array(def.tiles()).contains(inp.tiles)
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.entities()).is_empty()
	assert_that(def.input).is_not_null()
	assert_array(def.input.tiles).contains(inp.tiles)

func test_room_def_inputs_player_room_sets_entities_and_shape():
	var def = VaniaRoomDef.new()
	var inp = MapInput.apply(
		MapInput.merge_many([
			MapInput.with({entity_ids=[DinoEntityIds.PLAYERSPAWNPOINT]}),
			MapInput.spaceship(),
			MapInput.small_room_shape()
		]), def)

	assert_array(inp.tiles).is_not_null()
	assert_array(inp.tiles).is_not_empty()
	assert_array(def.tiles()).contains(inp.tiles)
	assert_array(def.tiles()).is_not_empty()

	assert_that(inp.room_shape).is_not_null()
	assert_array(def.local_cells).is_not_empty()
	assert_array(def.local_cells).is_equal(inp.room_shape.cells)

	assert_array(inp.entities).is_not_empty()
	assert_array(def.entities()).is_not_empty()
	assert_that(inp.entities[0].get_entity_id()).is_equal(DinoEntityIds.PLAYERSPAWNPOINT)
	assert_that(def.entities()[0].get_entity_id()).is_equal(DinoEntityIds.PLAYERSPAWNPOINT)

func test_room_def_inputs_leaf_and_kingdom_have_fallback_room_shape():
	var def = VaniaRoomDef.new()
	var inp = MapInput.apply(
		MapInput.merge_many([
			MapInput.with({entity_ids=[DinoEntityIds.LEAF]}),
			MapInput.kingdom(),
		]), def)

	assert_array(inp.tiles).is_not_null()
	assert_array(inp.tiles).is_not_empty()
	assert_array(def.tiles()).contains(inp.tiles)

	assert_array(inp.entities).is_not_empty()
	assert_array(def.entities()).is_not_empty()
	assert_that(inp.entities[0].get_entity_id()).is_equal(DinoEntityIds.LEAF)
	assert_that(def.entities()[0].get_entity_id()).is_equal(DinoEntityIds.LEAF)

	# room shapes input is empty, but the def's local_cells is not!
	assert_array(inp.room_shapes).is_empty()
	assert_array(def.local_cells).is_not_empty()
	# local_cells is set by all_room_shapes static var
	# shape lib isn't normalized but local_cells is
	# assert_array(inp.all_room_shapes.values()).contains([def.local_cells])

## apply ######################################################

func test_apply_keeps_local_cells():
	var def = VaniaRoomDef.new()
	var _inp = MapInput.apply(MapInput.small_room_shape(), def)

	assert_array(def.local_cells).is_equal(RoomShape.all_room_shapes[RoomShape.T.SMALL])

	var my_local_cells = [Vector3i(0, 0, 0)]
	def = VaniaRoomDef.new({local_cells=my_local_cells})
	_inp = MapInput.apply(MapInput.large_room_shape(), def)

	assert_array(def.local_cells).is_equal(my_local_cells)

func test_apply_appends_multiple_entities():
	var def = VaniaRoomDef.new()
	var inp = MapInput.apply(
			MapInput.with({entity_ids=[
				DinoEntityIds.TARGET,
				DinoEntityIds.TARGET,
				DinoEntityIds.PLAYERSPAWNPOINT,
				]}), def)

	assert_int(len(inp.entities)).is_equal(3)
	assert_int(len(def.entities())).is_equal(3)
	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
	assert_array(def.entities().map(func(ent): return ent.get_entity_id())).contains(
		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])

# an idea, but better when we have type unions
# func test_apply_supports_dicts_and_opts():
# 	var def = VaniaRoomDef.new()
# 	# pass just a dict
# 	var inp = MapInput.apply_constraints({
# 			MapInput.HAS_TARGET: {count=4},
# 			MapInput.HAS_PLAYER: {}
# 			}, def)

# 	assert_int(len(inp.entities)).is_equal(5)
# 	assert_int(len(def.entities)).is_equal(5)
# 	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
# 		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
# 	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
# 		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])

# 	def = VaniaRoomDef.new()
# 	# pass an array of dict
# 	inp = MapInput.apply_constraints([{
# 			MapInput.HAS_TARGET: {count=4},
# 			MapInput.HAS_PLAYER: {}
# 			}], def)

# 	assert_int(len(inp.entities)).is_equal(5)
# 	assert_int(len(def.entities)).is_equal(5)
# 	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
# 		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
# 	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
# 		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])

# 	def = VaniaRoomDef.new()
# 	# pass an array of dicts
# 	inp = MapInput.apply_constraints([{
# 			MapInput.HAS_TARGET: {count=4},
# 		}, {
# 			MapInput.HAS_PLAYER: {}
# 		}], def)

# 	assert_int(len(inp.entities)).is_equal(5)
# 	assert_int(len(def.entities)).is_equal(5)
# 	assert_array(inp.entities.map(func(ent): return ent.get_entity_id())).contains(
# 		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
# 	assert_array(def.entities.map(func(ent): return ent.get_entity_id())).contains(
# 		[DinoEntityIds.TARGET, DinoEntityIds.PLAYERSPAWNPOINT,])
