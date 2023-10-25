extends Node2D

@export var type = "jetpack" # (String, "jetpack", "hat", "body")

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.animation = type
	Respawner.register_respawn(self)
	Cam.add_offscreen_indicator(self)
	Util.animate(self)
	Util.animate_rotate(self)


func kill():
	DJZ.play(DJZ.S.pickup)
	queue_free()


func _on_Area2D_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			if type:
				body.collect_pickup(type)
			kill()
