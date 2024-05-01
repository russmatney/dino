extends SSWeapon

func aim(aim_vector: Vector2):
	var dir

	if aim_vector.y > 0:
		dir = Vector2.DOWN
	elif aim_vector.y < 0:
		dir = Vector2.UP
	elif aim_vector.x > 0:
		dir = Vector2.RIGHT
	elif aim_vector.x < 0:
		dir = Vector2.LEFT

	match (dir):
		Vector2.UP:
			rotation_degrees = -90.0
			position.x = -8
			position.y = -10
			scale.x = 1
		Vector2.DOWN:
			rotation_degrees = 90.0
			position.x = 9
			position.y = 12
			scale.x = 1
		Vector2.LEFT:
			rotation_degrees = 0.0
			position.x = -9
			position.y = -10
			scale.x = -1
		Vector2.RIGHT:
			rotation_degrees = 0.0
			position.x = 9
			position.y = -10
			scale.x = 1

func activate():
	if actor and actor.has_method("notif"):
		actor.notif(self.name)
	Sounds.play(Sounds.S.swordswing)

func deactivate():
	pass

func use():
	swing()

func stop_using():
	pass

######################################################
# ready

func _on_animation_finished():
	if anim.animation == "swing":
		swinging = false
		anim.play("idle")


######################################################
# swing

func facing_dir():
	if scale.x > 0:
		return Vector2.RIGHT
	elif scale.x < 0:
		return Vector2.LEFT

var swinging
var bodies_this_swing = []
func swing():
	if swinging:
		return

	swinging = true
	bodies_this_swing = []
	anim.play("swing")
	Sounds.play(Sounds.S.swordswing)
	Cam.screenshake(0.18)

func _on_frame_changed():
	if anim.animation == "swing" and anim.frame in [1, 2, 3]:
		for b in bodies:
			if b.has_method("take_hit"):
				if not b in bodies_this_swing:
					Cam.hitstop("swordhit", 0.3, 0.1)
					bodies_this_swing.append(b)
					b.take_hit({damage=1, direction=facing_dir()})
			if b.has_method("fire_back"):
				if not b in bodies_this_swing:
					Cam.hitstop("swordhit", 0.3, 0.2)
					bodies_this_swing.append(b)
					b.fire_back()

		var needs_redraw = []
		for bs in body_shapes:
			var b = bs[1]
			if b.has_method("destroy_tile_with_rid"):
				var destroyed = b.destroy_tile_with_rid(bs[0])
				if destroyed:
					Sounds.play(Sounds.S.destroyed_block)
					if not b in needs_redraw:
						needs_redraw.append(b)

		for b in needs_redraw:
			var cells = b.get_used_cells(0)
			b.set_cells_terrain_connect(0, cells, 0, 0, false)
