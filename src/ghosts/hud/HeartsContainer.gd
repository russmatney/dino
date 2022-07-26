tool
extends HBoxContainer

var heart_icons
export(int) var h setget set_health


func _ready():
	if Engine.editor_hint:
		request_ready()

	call_deferred("find_heart_icons")


func find_heart_icons():
	heart_icons = get_children()


## Converts a passed int into a number of hearts to display.
func set_health(health):
	# TODO extend to add and place more hearts, or layer a new color on top

	if not heart_icons:
		find_heart_icons()

	if not heart_icons:
		return

	h = health
	var hearts = health / 2.0

	var hearts_floor = int(hearts)

	# full hearts indexed below health / 2
	for x in range(hearts_floor):
		if heart_icons.size() > x:
			heart_icons[x].animation = "full"

	# empty hearts indexed above health / 2
	for x in range(hearts_floor, 1 + heart_icons.size()):
		if heart_icons.size() > x:
			heart_icons[x].animation = "empty"

	# half heart should overwrite an empty heart
	if hearts > hearts_floor:
		if heart_icons.size() > hearts_floor:
			heart_icons[hearts_floor].animation = "half"
