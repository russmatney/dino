extends Pickup

func _ready():
	actions = [
		Action.mk({label="Pickup Shrine Gem",
			source_can_execute=func(): return picked_up == false,
			fn=func(actor):
			actor.add_shrine_gem()
			fade_out()
			})
		]

	anim.animation_finished.connect(func():
		if anim.animation == "shine":
			anim.play("gem"))

	var t = create_tween()
	t.set_loops()
	t.tween_callback(anim.play.bind("shine")).set_delay(3)
