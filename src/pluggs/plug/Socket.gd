extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D

var plug

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if plug != null:
		return

	Debug.pr("socket body entered", body)

	if body.is_in_group("plug") and not body.is_latched:
		var latched = body.latch(self)
		if latched:
			plug = body
