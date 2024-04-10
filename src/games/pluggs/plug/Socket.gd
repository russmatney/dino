extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D

var plug

signal plugged(plug)
signal unplugged(plug)

func _ready():
	area.body_entered.connect(_on_body_entered)

func unplug():
	if plug != null and is_instance_valid(plug):
		plug.reached_length()
		unplugged.emit(plug)
	plug = null

func _on_body_entered(body):
	if plug != null:
		return

	if body.is_in_group("plug") and not body.is_latched:
		var latched = body.latch(self)
		if latched:
			plug = body
			plugged.emit(plug)
