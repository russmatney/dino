extends Node2D

@export var type = "jetpack" # (String, "jetpack", "hat", "body")


func _ready():
	$AnimatedSprite2D.animation = type
	Respawner.register_respawn(self)
	Cam.add_offscreen_indicator(self)
	Util.animate(self)
	Util.animate_rotate(self)


func kill():
	GunnerSounds.play_sound("pickup")
	# TODO animate
	queue_free()


func _on_Area2D_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			if type:
				body.collect_pickup(type)
			kill()
