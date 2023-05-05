@tool
extends VBoxContainer

@onready var tt_sound = preload("res://addons/dj/TurnTableSound.tscn")

func _ready():
	for c in get_children():
		c.free()

	for s in DJZ.S.keys():
		var tt = tt_sound.instantiate()
		tt.ready.connect(tt.set_sound.bind(s))
		add_child(tt)
