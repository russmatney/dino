extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var socket = $Socket
@onready var light = $PointLight2D

var is_plugged = false

signal plugged

func _ready():
	socket.plugged.connect(_on_plugged)
	socket.unplugged.connect(_on_unplugged)

	if is_plugged:
		_on_plugged()
	else:
		_on_unplugged()

func _on_plugged(_plug=null):
	anim.play("idle-on")
	light.set_enabled(true)
	plugged.emit()

func _on_unplugged(_plug=null):
	anim.play("idle-off")
	light.set_enabled(false)
