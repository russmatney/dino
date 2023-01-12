extends GutTest


func test_util_remove_matching():
	var some_d = {"this": "is a dictionary", "with": 5, "data": "points"}
	var some_other_d = {"this": "is another dictionary", "with": 5, "data": "points"}
	var arr = [some_d, some_other_d]
	var to_remove = [some_d]

	var removed = Util.remove_matching(arr, to_remove)

	assert_eq(removed.size(), 1)
	assert_eq(removed[0].hash(), some_other_d.hash())
