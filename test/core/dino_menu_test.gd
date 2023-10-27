extends GdUnitTestSuite

var main_scene_path = ProjectSettings.get("application/run/main_scene")

# TODO restore or rewrite
# func test_main_scene_loads_with_focus():
# 	var main_menu = load(main_scene_path).instantiate()
# 	add_child.call_deferred(main_menu)
# 	await main_menu.ready

# 	var something_focused
# 	for c in Util.get_all_children(main_menu):
# 		if c.has_method("has_focus") and c.has_focus():
# 			something_focused = true
# 			break

# 	assert_that(something_focused).is_true()

# 	main_menu.free()
