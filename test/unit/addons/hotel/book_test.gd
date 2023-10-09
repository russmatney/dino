extends GutTest


func test_book_demo_land_zone():
	var zone_path = "res://src/demoland/zones/area01/Area01.tscn"
	var zone = load(zone_path).instantiate()
	add_child(zone)

	Hotel.register(zone)
	var data = Hotel.check_out(zone)

	assert_eq(data.name, "Area01")
	assert_eq(data.groups as Array, ["metro_zones"])

	var room_name = "10JumpRoom"
	var room_data = Hotel.first({filter=func(d): return d.name == room_name})

	assert_eq(room_data.name, room_name)
	assert_eq(room_data.groups as Array, [&"metro_rooms"])

	zone.queue_free()
