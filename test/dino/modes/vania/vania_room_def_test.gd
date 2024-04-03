extends GdUnitTestSuite
class_name VaniaRoomDefTest

##########################################################################
## pixel coords ###########################################################

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

##########################################################################
## tile coords ###########################################################


##########################################################################
## map_cell coords ###########################################################
