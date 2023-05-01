extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var destroyed_label_scene = preload("res://src/gunner/targets/DestroyedLabel.tscn")

signal destroyed(target)


func _ready():
	Debug.pr("target ready")
	anim.animation_finished.connect(_animation_finished)
	Respawner.register_respawn(self)
	Cam.add_offscreen_indicator(self)
	Util.animate(self)
	Util.animate_rotate(self)


func _animation_finished():
	if anim.animation == "pop":
		queue_free()


func kill():
	Hood.notif("Target Destroyed")
	DJZ.play(DJZ.target_kill)
	anim.play("pop")
	Cam.freezeframe("target-destroyed", 0.05, 0.4)
	destroyed.emit(self)

	var lbl = destroyed_label_scene.instantiate()
	lbl.set_position(get_global_position())
	Navi.current_scene.add_child.call_deferred(lbl)


func _on_Target_body_entered(body: Node):
	if body.is_in_group("bullet"):
		if body.has_method("kill"):
			body.kill()
		kill()
