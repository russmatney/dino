extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var socket = $Socket

var is_plugged = false

func _ready():
	socket.plugged.connect(_on_plugged)
	socket.unplugged.connect(_on_unplugged)

	if is_plugged:
		_on_plugged()
	else:
		_on_unplugged()

func _on_plugged(_plug=null):
	anim.play("idle-on")

func _on_unplugged(_plug=null):
	anim.play("idle-off")
