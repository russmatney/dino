extends Node2D

@export var type = "jetpack" # (String, "jetpack", "hat", "body")


func _ready():
	$AnimatedSprite2D.animation = type
	Respawner.register_respawn(self)

	animate()
	animate_rotate()


func animate_rotate():
	var tween = create_tween()
	tween.set_loops(0)
	tween.tween_property($AnimatedSprite2D, "rotation", rotation + PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property($AnimatedSprite2D, "rotation", rotation - PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)


func animate():
	var og_pos = position
	var rand_offset = Vector2(randi() % 10 * 1.0 - 10.0 / 2.0, randi() % 10 * 1.0 - 10.0 / 2.0)
	var tween = create_tween()
	tween.tween_property(self, "position", position + rand_offset, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(self, "position", og_pos, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_callback(Callable(self,"animate")).set_delay(randf_range(0.3, 2.0))


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


@onready var offscreen_indicator = $OffscreenIndicator


func _process(_delta):
	# if target offscreen and player close enough/line-of-sight
	if not on_screen:
		offscreen_indicator.activate(self)
	else:
		offscreen_indicator.deactivate()


var on_screen = false


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
