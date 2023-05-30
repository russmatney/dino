extends SSWeapon

func aim(_aim_vector: Vector2):
	pass

func activate():
	pass

func deactivate():
	pass

func use():
	burst()

func stop_using():
	pass

######################################################
# ready

func _on_animation_finished():
	if anim.animation == "burst":
		bursting = false
		anim.visible = false


######################################################
# swing

var bursting
var bodies_this_swing = []
func burst():
	if bursting:
		# consider combos
		return

	Cam.hitstop("MEGAHITSTOP", 0.01, 0.4, 0.5)

	bursting = true
	bodies_this_swing = []

	anim.visible = true
	anim.play("burst")
	DJZ.play(DJZ.S.swordswing)

func _on_frame_changed():
	if anim.animation == "burst" and anim.frame in [1, 2, 3]:
		for b in bodies:
			if b.has_method("stun"):
				b.stun()
