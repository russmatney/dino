extends Node2D

func _on_Area2D_body_entered(body:Node):
	if body.has_method("add_coin"):
		body.add_coin()
		queue_free()
