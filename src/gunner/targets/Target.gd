extends Area2D


onready var anim = $AnimatedSprite

func _ready():
	anim.connect("animation_finished", self, "_animation_finished")

func _animation_finished():
	if anim.animation == "pop":
		Engine.set_time_scale(1)
		queue_free()

func kill():
	Gunner.play_sound("target_kill")
	anim.animation = "pop"
	Engine.set_time_scale(0.5)


func _on_Target_body_entered(body:Node):
	if body.is_in_group("bullet"):
		if body.has_method("kill"):
			body.kill()

		kill()
