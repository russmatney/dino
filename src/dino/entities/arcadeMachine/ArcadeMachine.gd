extends Node2D

@onready var anim = $AnimatedSprite2D
# @onready var light = $PointLight2D

func _ready():
	pass

func _on_plugged(_plug=null):
	anim.play("idle-on")
	# light.set_enabled(true)

func _on_unplugged(_plug=null):
	anim.play("idle-off")
	# light.set_enabled(false)
