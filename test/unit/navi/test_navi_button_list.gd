extends GutTest

var scene_path = "res://test/unit/navi/NaviButtonListTest.tscn"
var scene = load(scene_path)

var m


func before_each():
	m = autofree(scene.instance())
	add_child(m)


func get_button(idx = 0):
	var buttons = m.get_buttons()
	if buttons.size() > 0:
		return buttons[idx]


func test_add_one_menu_item():
	var label = "My button label"
	m.add_menu_item({"label": label})

	# we should only have one button
	var buttons = m.get_buttons()
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

	var buttons = m.get_buttons()
	assert_eq(buttons.size(), labels.size(), "Added multiple buttons")

	var button_texts = []
	for but in buttons:
		button_texts.append(but.text)
		assert_true(but.text in labels, "Button should be one of these")
	for l in labels:
		assert_true(l in button_texts, "Every label should be found")


func test_does_not_add_duplicates():
	var labels = ["fred", "wilma", "fred", "wilma"]
	for label in labels:
		m.add_menu_item({"label": label})

	var buttons = m.get_buttons()
	assert_eq(buttons.size(), 2, "Added only 2 buttons")


var inc = 0


func some_button_incrementer():
	inc += 1


func test_pressed_buttons_call_functions():
	m.add_menu_item(
		{
			"label": "My button",
			"obj": self,
			"method": "some_button_incrementer",
		}
	)

	var button = get_button()
	assert_eq(inc, 0, "inc is initially 0")
	button.emit_signal("pressed")
	assert_eq(inc, 1, "inc is incremented to 1")


func test_menu_items_with_nav_to():
	# autoloads are not easily doubled
	m._navi = double("res://addons/navi/Navi.gd").new()

	var some_path = scene_path
	var button_desc = {
		"label": "My button",
		"nav_to": some_path,
	}
	m.add_menu_item(button_desc)

	var button = get_button()
	button.emit_signal("pressed")

	assert_called(m._navi, "nav_to", [some_path])


func test_disables_buttons_with_functions():
	# no function
	m.add_menu_item({"label": "Fred button"})
	# method does not exist
	m.add_menu_item({"label": "Barney button", "obj": self, "method": "does_not_exist"})
	# resource does not exist
	m.add_menu_item({"label": "Barney nav button", "nav_to": "res://does_not_exist.tscn"})

	var buttons = m.get_buttons()
	assert_eq(buttons.size(), 3, "Added 3 buttons")

	for button in buttons:
		assert_true(button.disabled, "Should be disabled: " + button.text)
