extends Area2D


onready var anim = $AnimatedSprite
onready var destroyed_label_scene = preload("res://src/gunner/targets/DestroyedLabel.tscn")

signal destroyed(target)

func _ready():
	anim.connect("animation_finished", self, "_animation_finished")

	Gunner.register_respawn(self)

func _animation_finished():
	if anim.animation == "pop":
		queue_free()

func kill():
	Gunner.play_sound("target_kill")
	anim.animation = "pop"
	Cam.freezeframe("target-destroyed", 0.05, 0.4)
	emit_signal("destroyed", self)

	var lbl = destroyed_label_scene.instance()
	lbl.set_position(get_global_position())
	Navi.current_scene.call_deferred("add_child", lbl)

func _on_Target_body_entered(body:Node):
	if body.is_in_group("bullet"):
		if body.has_method("kill"):
			body.kill()

		kill()
