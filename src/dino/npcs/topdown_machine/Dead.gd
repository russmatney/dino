extends State

## enter ###########################################################

func enter(_opts = {}):
	if actor.anim.sprite_frames.has_animation("dead"):
		actor.anim.play("dead")
	else:
		actor.anim.stop()
		var t = create_tween()
		t.tween_property(actor, "modulate:a", 0.2, 1)
	actor.died.emit()


## physics ###########################################################

func physics_process(_delta):
	actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.8)
	actor.move_and_slide()
