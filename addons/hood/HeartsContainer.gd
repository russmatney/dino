@tool
extends HBoxContainer

@export var h: int : set = set_health

@export var flip_h = false :
	set = set_flip_h

func set_flip_h(v):
	if v != flip_h:
		flip_h = v
		set_health(h)

		if flip_h:
			alignment = ALIGNMENT_END
		else:
			alignment = ALIGNMENT_BEGIN


func _ready():
	if Engine.is_editor_hint():
		request_ready()

var heart_icon_scene = preload("res://addons/hood/HeartIcon.tscn")

## Converts a passed int into a number of hearts to display.
## As implemented, 1 heart is 2 HP.
func set_health(health):
	if health == null:
		Debug.warn("[HOOD] WARN: set_health with null!")
		return

	health = clamp(health, 0, health)

	var heart_icons = []

	if len(heart_icons) == 0:
		heart_icons = get_children()

		# make extra certain we don't add more icons too early
		if len(heart_icons) != null and len(heart_icons) > 0 \
			and len(heart_icons) < health/2.0:
			var to_add =  health / 2.0 - len(heart_icons)
			to_add = ceil(to_add)
			for _i in range(to_add):
				var new_heart = heart_icon_scene.instantiate()
				add_child(new_heart)

		heart_icons = get_children()

		if flip_h:
			heart_icons.reverse()

		for icon in heart_icons:
			icon.flip_h = flip_h

	if heart_icons.size() == 0:
		return

	h = health
	var hearts = health / 2.0

	var hearts_floor = int(hearts)

	# full hearts indexed below health / 2
	for x in range(hearts_floor):
		if heart_icons.size() > x:
			heart_icons[x].set_full()

	# empty hearts indexed above health / 2
	for x in range(hearts_floor, 1 + heart_icons.size()):
		if heart_icons.size() > x and x >= 0:
			heart_icons[x].set_empty()

	# half heart should overwrite an empty heart
	if hearts > hearts_floor:
		if heart_icons.size() > hearts_floor and hearts_floor >= 0:
			heart_icons[hearts_floor].set_half()
