@tool
extends TextureRect

@export_enum("empty", "half", "full") var state = "half": set = set_state

func set_state(s):
	if s != state:
		state = s
		match(s):
			"empty": set_empty()
			"half": set_half()
			"full": set_full()

func set_empty():
	state = "empty"
	if texture:
		texture.region.position.x = 64

func set_half():
	state = "half"
	if texture:
		texture.region.position.x = 32

func set_full():
	state = "full"
	if texture:
		texture.region.position.x = 0
