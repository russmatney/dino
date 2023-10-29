extends GdUnitTestSuite
class_name CameraTestSuite

func test_request_camera_basic():
	var some_node = Node2D.new()

	var cam = Cam.request_camera({player=some_node})
	assert_that(cam).is_not_null()

	cam.free()
	some_node.free()
