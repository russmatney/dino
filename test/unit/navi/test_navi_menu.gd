extends GutTest

var menu_scene = load("res://test/unit/navi/NaviMenuTest.tscn")

var m


func before_each():
	m = autofree(menu_scene.instance())
	add_child(m)

func get_button(idx=0):
	var buttons = m.menu_list.get_children()
	if buttons.size() > 0:
		return buttons[idx]


func test_add_one_menu_item():
	var label = "My button label"
	m.add_menu_item({"label": label})

	# we should only have one button
	var buttons = m.menu_list.get_children()
	assert_eq(buttons.size(), 1, "Added one button")

	# make sure our button label is as expected
	var but = get_button()
	assert_eq(but.text, label, "With the expected label")

	# not method assigned, emitting this does not crash
	but.emit_signal("pressed")


func test_add_multiple_menu_items():
	var labels = ["fred", "wilma", "barney", "betty"]
	for label in labels:
		m.add_menu_item({"label": label})

	var buttons = m.menu_list.get_children()
	assert_eq(buttons.size(), labels.size(), "Added multiple buttons")

	var button_texts = []
	for but in buttons:
		button_texts.append(but.text)
		assert_true(but.text in labels, "Button should be one of these")
	for l in labels:
		assert_true(l in button_texts, "Every label should be found")


var inc = 0


func some_button_incrementer():
	inc += 1


func test_pressed_buttons_call_functions():
	var button_desc = {
		"label": "My button",
		"obj": self,
		"method": "some_button_incrementer",
	}
	m.add_menu_item(button_desc)

	var button = get_button()
	assert_eq(inc, 0, "inc is initially 0")
	button.emit_signal("pressed")
	assert_eq(inc, 1, "inc is incremented to 1")


func test_menu_items_with_nav_to():
	# autoloads are not easily doubled
	m._navi = double("res://addons/navi/Navi.gd").new()

	var some_path = "res://fred/flintstone.tscn"
	var button_desc = {
		"label": "My button",
		"nav_to": some_path,
	}
	m.add_menu_item(button_desc)

	var button = get_button()
	button.emit_signal("pressed")

	assert_called(m._navi, "nav_to", [some_path])
