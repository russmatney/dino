tool
extends AnimatedSprite

export(String, "dark", "blue", "red", "yellow") var anim = "dark" setget set_anim

func set_anim(v):
	animation = v

func _ready():
	pass
