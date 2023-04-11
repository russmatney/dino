extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var destroyed_label_scene = preload("res://src/gunner/targets/DestroyedLabel.tscn")

@onready var offscreen_indicator = $OffscreenIndicator

signal destroyed(target)


func _ready():
	Debug.pr("target ready")
	anim.animation_finished.connect(_animation_finished)
	Respawner.register_respawn(self)

	animate()
	animate_rotate()


func animate_rotate():
	var tween = create_tween()
	tween.set_loops(0)
	tween.tween_property(anim, "rotation", rotation + PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim, "rotation", rotation - PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)


func animate():
	var n = 10
	var og_pos = position
	var rand_offset = Vector2(randi() % n - n / 2.0, randi() % n - n / 2.0)
	var tween = create_tween()
	tween.tween_property(self, "position", position + rand_offset, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(self, "position", og_pos, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_callback(animate).set_delay(randf_range(0.3, 2.0))


func _process(_delta):
	if not on_screen:
		offscreen_indicator.activate(self)
	else:
		offscreen_indicator.deactivate()


func _animation_finished():
	if anim.animation == "pop":
		queue_free()


func kill():
	Hood.notif("Target Destroyed")
	GunnerSounds.play_sound("target_kill")
	anim.animation = "pop"
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


var on_screen = false


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
