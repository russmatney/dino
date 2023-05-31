extends SSWeapon

func aim(_aim_vector: Vector2):
	pass

func activate():
	pass

func deactivate():
	pass

func use():
	pass

func stop_using():
	pass

######################################################
# ready

func _on_animation_finished():
	anim.play("idle")

func _on_frame_changed():
	for b in bodies:
		if b.has_method("stun"):
			b.stun()
