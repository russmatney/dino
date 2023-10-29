extends GdUnitTestSuite
class_name CameraTestSuite

func test_request_camera_basic():
	var cam = Cam.request_camera()

	assert_that(cam).is_not_null()
