extends GutTest


func test_demo_land_zone():
	var zone_path = "res://src/demoland/zones/area01/Area01.tscn"
	var zone = load(zone_path).instantiate()
	add_child(zone)

	Hotel.register(zone)
	var data = Hotel.check_out(zone)

	assert_eq(data.name, "Area01")
	assert_has(data.groups, "metro_zones")
	assert_eq(data.scene_file_path, zone_path)
	assert_eq(data.key, "Area01")

	var room_name = "10JumpRoom"
	var room_data = Hotel.first({filter=func(d): return d.name == room_name})

	assert_eq(room_data.name, room_name)
	assert_has(room_data.groups, "metro_rooms")
	assert_string_ends_with(room_data.key, "Area01/10JumpRoom")

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
	assert_string_ends_with(k, "SomeObj")

	Hotel.register(node)
	var has = Hotel.has(node)
	assert_eq(has, true)

	var data = Hotel.check_out(node)

	assert_eq(data.name, node.name)
	assert_eq(data.cls, "Node")

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
	assert_eq(k, "SomeRootObj")

	Hotel.register(node)
	var has = Hotel.has(node)
	assert_eq(has, true)

	var data = Hotel.check_out(node)

	assert_eq(data.name, node.name)
	assert_eq(data.cls, "Node")

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
	assert_string_ends_with(k, "SomeObj_unique")

	Hotel.register(node)
	var has = Hotel.has(node)
	assert_eq(has, true)

	var data = Hotel.check_out(node)
	assert_eq(data.name, node.name)
	assert_eq(data.cls, "Node")

	node.free()
