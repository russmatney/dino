extends SSWeapon

var aim_vector
var toss_offset = Vector2.ONE * -12

func aim(aim_v: Vector2):
	aim_vector = aim_v
	anim.rotation = aim_vector.angle()

func activate():
	Debug.pr("activating", self)
	actor.notif(self.name)
	DJZ.play(DJZ.S.laser)

func deactivate():
	pass

func use():
	if not tossing:
		if actor.pickups.size() > 0:
			var pickup_type = actor.pickups[0]
			actor.remove_orbit_item(pickup_type)
			toss(pickup_type)

func stop_using():
	pass

######################################################
# ready

func _on_animation_finished():
	pass

func _on_frame_changed():
	pass

######################################################
# toss

var tossing = false
var cooldown = 0.2

# TODO use/apply data for specifc pickup
# TODO pull stats from pickup
@onready var tossed_item_scene = preload("res://src/spike/entities/TossedItem.tscn")
var impulse = 300
var knockback = 1

func toss(pickup):
	Debug.pr("tossing pickup:", pickup)
	tossing = true

	if aim_vector == null:
		aim_vector = Vector2.RIGHT

	var item = tossed_item_scene.instantiate()
	item.pickup_type = pickup
	item.position = global_position + toss_offset
	item.add_collision_exception_with(actor)


	Navi.current_scene.add_child.call_deferred(item)
	item.rotation = aim_vector.angle()
	item.apply_impulse(aim_vector * impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)

	await get_tree().create_timer(cooldown).timeout
	# be sure to remove the collision exception, or we can't pick it up again
	item.remove_collision_exception_with(actor)
	tossing = false
