extends AnimatedSprite2D

@onready var hitbox = $HitBox

######################################################
# ready

func _ready():
	animation_finished.connect(_on_animation_finished)
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)

	hitbox.body_shape_entered.connect(_on_body_shape_entered)
	hitbox.body_shape_exited.connect(_on_body_shape_exited)
	bodies_updated.connect(_on_bodies_updated)
	frame_changed.connect(_on_frame_changed)

func _on_animation_finished():
	if animation == "swing":
		swinging = false
		play("idle")

func hit_rect():
	var shape_rect = $HitBox/CollisionShape2D.shape.get_rect()
	Debug.prn("shape_rect", shape_rect)
	shape_rect.position = to_global(shape_rect.position)
	return shape_rect


######################################################
# bodies

signal bodies_updated(bodies)
var bodies = []
var body_shapes = []

func _on_body_entered(body: Node2D):
	bodies.append(body)
	bodies_updated.emit(bodies)

func _on_body_exited(body: Node2D):
	bodies.erase(body)
	bodies_updated.emit(bodies)

func _on_bodies_updated(_bds):
	pass
	# Debug.debug_label("Sword bodies: ", bodies)
	# Debug.debug_label("Sword body shapes: ", body_shapes)

func _on_body_shape_entered(rid, body: Node2D, _bs_idx, _local_idx):
	body_shapes.append([rid, body])
	bodies_updated.emit(bodies)

func _on_body_shape_exited(rid, body: Node2D, _bs_idx, _local_idx):
	body_shapes.erase([rid, body])
	bodies_updated.emit(bodies)


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
		# consider combos
		return

	swinging = true
	bodies_this_swing = []
	play("swing")
	MvaniaSounds.play_sound("swordswing")
	Cam.screenshake(0.18)

func _on_frame_changed():
	if animation == "swing" and frame in [1, 2, 3]:
		for b in bodies:
			if b.has_method("take_hit"):
				if not b in bodies_this_swing:
					Cam.hitstop("swordhit", 0.3, 0.1)
					bodies_this_swing.append(b)
					var dir = facing_dir()
					b.take_hit({"damage": 1, "direction": dir})
			if b.has_method("fire_back"):
				if not b in bodies_this_swing:
					Cam.hitstop("swordhit", 0.3, 0.2)
					bodies_this_swing.append(b)
					b.fire_back()

		var needs_redraw = []
		for bs in body_shapes:
			var b = bs[1]
			if b.has_method("destroy_tile_with_rid"):
				# TODO prevent extra calls on each hit-frame if already hit
				var destroyed = b.destroy_tile_with_rid(bs[0])
				if destroyed:
					DJSounds.play_sound(DJSounds.destroyed_block)
					if not b in needs_redraw:
						needs_redraw.append(b)

		for b in needs_redraw:
			var cells = b.get_used_cells(0)
			b.set_cells_terrain_connect(0, cells, 0, 0, false)
