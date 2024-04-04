extends GdUnitTestSuite
class_name VaniaRoomDefTest

## get size ###########################################################

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


## init ###################################################################

func test_creating_with_room_inputs():
	var rd = VaniaRoomDef.new({room_inputs=[RoomInputs.IN_SMALL_ROOM]})
	assert_array(rd.local_cells).is_equal([Vector3i(0, 0, 0)])

	# should normalize room shapes
	rd = VaniaRoomDef.new({room_inputs={
		RoomInputs.CUSTOM_ROOM: {shape=[Vector3i(-4, 8, 0)]}
		}})
	assert_array(rd.local_cells).is_equal([Vector3i(0, 0, 0)])
