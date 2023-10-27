extends GdUnitTestSuite


func test_demo_land_zone():
	var zone_path = "res://src/demoland/zones/area01/Area01.tscn"
	var zone = load(zone_path).instantiate()
	add_child(zone)

	Hotel.register(zone)
	var data = Hotel.check_out(zone)

	assert_that(data.name).is_equal("Area01")
	assert_that(data.groups).contains(["metro_zones"])
	assert_that(data.scene_file_path).is_equal(zone_path)
	assert_that(data.key).is_equal("Area01")

	var room_name = "10JumpRoom"
	var room_data = Hotel.first({filter=func(d): return d.name == room_name})

	assert_that(room_data.name).is_equal(room_name)
	assert_that(room_data.groups).contains(["metro_rooms"])
	assert_that(room_data.key).ends_with("Area01/10JumpRoom")

	zone.queue_free()

## basic object ###########################

class SomeObj:
	extends Node

	func hotel_data():
		return {}

	func check_out(_d):
		pass

func test_register_basic():
	var node = SomeObj.new()
	node.name = "SomeObj"
	add_child(node)
	var k = Hotel._node_to_entry_key(node)
	assert_that(k).ends_with("SomeObj")

	Hotel.register(node)
	var has = Hotel.has(node)
	assert_that(has).is_equal(true)

	var data = Hotel.check_out(node)

	assert_that(data.name).is_equal(node.name)
	assert_that(data.cls).is_equal("Node")

	node.free()

## root object ###########################

class SomeRootObj:
	extends Node

	func is_hotel_root():
		return true

	func hotel_data():
		return {}

	func check_out(_d):
		pass

func test_register_root():
	var node = SomeRootObj.new()
	node.name = "SomeRootObj"
	add_child(node)
	var k = Hotel._node_to_entry_key(node)
	assert_that(k).is_equal("SomeRootObj")

	Hotel.register(node)
	var has = Hotel.has(node)
	assert_that(has).is_equal(true)

	var data = Hotel.check_out(node)

	assert_that(data.name).is_equal(node.name)
	assert_that(data.cls).is_equal("Node")

	node.free()

## custom key object ###########################

class SomeObjUniqueKey:
	extends Node

	func hotel_key_suffix():
		return "_unique"

	func hotel_data():
		return {}

	func check_out(_d):
		pass

func test_register_unique_key():
	var node = SomeObjUniqueKey.new()
	node.name = "SomeObj"
	add_child(node)
	var k = Hotel._node_to_entry_key(node)
	assert_that(k).ends_with("SomeObj_unique")

	Hotel.register(node)
	var has = Hotel.has(node)
	assert_that(has).is_equal(true)

	var data = Hotel.check_out(node)
	assert_that(data.name).is_equal(node.name)
	assert_that(data.cls).is_equal("Node")

	node.free()
