extends GutTest

class TestBasicHotelUsage:
	extends GutTest

	var scene = preload("res://test/unit/addons/hotel/BasicHotelScene.tscn")
	var node

	func before_all():
		node = scene.instantiate()
		add_child(node)

	func test_registered_data():
		var data = Hotel.check_out(node)
		assert_not_null(data)
		Debug.pr(data)

		# assert on basic properties
		assert_eq(data.scene_file_path, "res://test/unit/addons/hotel/BasicHotelScene.tscn")
		assert_eq(data.key, "GutRunner/@Node@20/BasicHotelScene")
		assert_eq(data.name, &"BasicHotelScene")
		assert_eq(data.type, &"Node2D")
		assert_eq(data.groups as Array, [])

		# assert on custom/opt-in properties (based on BasicHotelScene.gd impl!)
		assert_eq(data.misc_data, null)

		# check_in some new data
		var val = 5
		Hotel.check_in(node, {misc_data=val})
		data = Hotel.check_out(node)
		assert_eq(data.misc_data, val)

		# assign some data, then check_in
		val = "hello there"
		node.misc_data = val
		Hotel.check_in(node)
		data = Hotel.check_out(node)
		assert_eq(data.misc_data, val)

	func test_entry_updated():
		var data = Hotel.check_out(node)
		watch_signals(Hotel)
		Hotel.check_in(node)
		assert_signal_emitted_with_parameters(Hotel, "entry_updated", [data])
