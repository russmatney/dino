@tool
extends HBoxContainer

@export var h: int : set = set_health

@export var flip_h = false :
	set = set_flip_h

func set_flip_h(v):
	if v != flip_h:
		flip_h = v
		set_health(h)



func _ready():
	if Engine.is_editor_hint():
		request_ready()


# TODO extend to add and place more hearts, or layer a new color checked top
## Converts a passed int into a number of hearts to display.
func set_health(health):
	health = clamp(health, 0, health)
	if health == null:
		Debug.warn("[HOOD] WARN: set_health with null!")
		return

	var heart_icons = []

	if len(heart_icons) == 0:
		heart_icons = get_children()

		if flip_h:
			heart_icons.reverse()

		for icon in heart_icons:
			icon.flip_h = not flip_h

	if heart_icons.size() == 0:
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
