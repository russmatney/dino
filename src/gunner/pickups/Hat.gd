extends Node2D

var type = "hat"


func kill():
	DJZ.play(DJZ.S.pickup)
	queue_free()


func _on_Area2D_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			body.collect_pickup(self.type)
			kill()
