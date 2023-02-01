extends Node2D

var type = "hat"


func _ready():
	Respawner.register_respawn(self)


func kill():
	GunnerSounds.play_sound("pickup")
	# TODO collect anim
	queue_free()


func _on_Area2D_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			body.collect_pickup(self.type)
			kill()
