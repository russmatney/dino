@tool
extends Node2D

@onready var pickup_box = $Area2D
var pickup_type = "blob"

func _ready():
	pickup_box.body_entered.connect(_on_body_entered)

func kill():
	DJZ.play(DJZ.S.pickup)
	# TODO animate
	queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			if pickup_type:
				body.collect_pickup(pickup_type)
			kill()
