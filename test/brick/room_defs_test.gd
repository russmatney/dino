extends GdUnitTestSuite

func test_room_defs_filter():
	var rd = RoomDefs.new()

	var rm_1 = RoomDef.new()
	rm_1.name = "room_1"
	rm_1.meta["some_flag"] = true
	var rm_2 = RoomDef.new()
	rm_2.name = "room_2"
	rd.rooms.append_array([rm_1, rm_2])

	var rooms = rd.filter({filter_rooms=func(room): return room.has_flag("some_flag")})
	Debug.pr("filtered rooms", rooms)
	Debug.pr("filtered room", rooms[0])

	assert_that(len(rooms)).is_equal(1)
	assert_that(rooms[0].name).is_equal("room_1")

	rooms = rd.filter({filter_rooms=func(room): return not room.has_flag("some_flag")})

	assert_that(len(rooms)).is_equal(1)
	assert_that(rooms[0].name).is_equal("room_2")