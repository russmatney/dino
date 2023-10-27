extends GdUnitTestSuite

var scene = preload("res://test/hotel/BasicHotelScene.tscn")
var node

# TODO rewrite hotel to not require a tree....?

# func test_registered_data():
# 	node = scene.instantiate()
# 	var data = Hotel.check_out(node)
# 	assert_that(data).is_not_null()

# 	# assert on basic properties
# 	assert_that(data.scene_file_path).is_equal("res://test/hotel/BasicHotelScene.tscn")
# 	# assert_that(data.key).starts_with("GutRunner/@Node")
# 	assert_that(data.key).ends_with("/BasicHotelScene")
# 	assert_that(data.name).is_equal(&"BasicHotelScene")
# 	assert_that(data.cls).is_equal("Node2D")
# 	# assert_that(data.groups as Array, [])

# 	# assert on custom/opt-in properties (based on BasicHotelScene.gd impl!)
# 	assert_that(data.misc_data).is_equal(null)

# 	# check_in some new data
# 	var val = 5
# 	Hotel.check_in(node, {misc_data=val})
# 	data = Hotel.check_out(node)
# 	assert_that(data.misc_data).is_equal(val)

# 	# assign some data, then check_in
# 	val = "hello there"
# 	node.misc_data = val
# 	Hotel.check_in(node)
# 	data = Hotel.check_out(node)
# 	assert_that(data.misc_data).is_equal(val)

# 	node.queue_free()

# TODO rewrite to watch signals
# func test_entry_updated():
# 	var data = Hotel.check_out(node)
# 	watch_signals(Hotel)
# 	Hotel.check_in(node)
# 	assert_signal_emitted_with_parameters(Hotel, "entry_updated", [data])
