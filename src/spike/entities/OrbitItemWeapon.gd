extends SSWeapon

var aim_vector
var toss_offset = Vector2.ONE * -12

func aim(aim_v: Vector2):
	aim_vector = aim_v
	# TODO point in aim direction (take flip_h into account?)
	if actor.facing_vector.x < 0:
		rotation = aim_vector.angle() + PI
	else:
		rotation = aim_vector.angle()

func activate():
	Debug.pr("activating", self)
	actor.notif(self.name)
	DJZ.play(DJZ.S.laser)

func deactivate():
	pass

func use():
	if not tossing and not spiking:
		if actor.pickups.size() > 0:
			var pickup_type = actor.pickups[0]
			if actor.in_spike_zone():
				actor.is_spiking = true
				start_spike(pickup_type)
			else:
				toss(pickup_type)
			actor.remove_orbit_item(pickup_type)

# TODO rename to use_pressed/use_released
func stop_using():
	Debug.pr("stop using orbit item")
	if spiking and spiking_pickup:
		do_spike(spiking_pickup)
		actor.is_spiking = false

######################################################
# ready

func _on_animation_finished():
	pass

func _on_frame_changed():
	pass

######################################################
# actions

var tossing = false
var spiking = false
var cooldown = 0.2

# TODO use/apply data for specifc pickup
# TODO pull stats from pickup
@onready var tossed_item_scene = preload("res://src/spike/entities/TossedItem.tscn")
var toss_impulse = 300
var knockback = 1

func toss(pickup):
	Debug.pr("tossing pickup:", pickup)
	tossing = true

	if aim_vector == null:
		aim_vector = actor.move_vector

	var item = tossed_item_scene.instantiate()
	item.pickup_type = pickup
	item.position = global_position + toss_offset
	item.add_collision_exception_with(actor)


	Navi.current_scene.add_child.call_deferred(item)
	# item.rotation = aim_vector.angle()
	item.apply_impulse(aim_vector * toss_impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)

	await get_tree().create_timer(cooldown).timeout
	# be sure to remove the collision exception, or we can't pick it up again
	if is_instance_valid(item):
		item.remove_collision_exception_with(actor)
	tossing = false

var spiking_pickup
var spike_impulse = 1000

func start_spike(pickup):
	spiking_pickup = pickup
	Cam.start_slowmo("spike_slowmo", 0.1)
	Debug.pr("start spike pickup:", pickup)
	spiking = true

# TODO animate the spike with a juicy trail/line graphic
func do_spike(pickup):
	Debug.pr("do spike pickup:", pickup)
	if aim_vector == null:
		aim_vector = actor.move_vector

	var item = tossed_item_scene.instantiate()
	item.pickup_type = pickup
	item.position = global_position + toss_offset
	item.add_collision_exception_with(actor)

	Navi.current_scene.add_child.call_deferred(item)
	# item.rotation = aim_vector.angle()
	item.apply_impulse(aim_vector * spike_impulse, Vector2.ZERO)

	Cam.stop_slowmo("spike_slowmo")
	DJZ.play(DJZ.S.fire)

	await get_tree().create_timer(cooldown).timeout
	# be sure to remove the collision exception (if it exists), or we can't pick it up again
	if is_instance_valid(item):
		item.remove_collision_exception_with(actor)
	spiking = false
	spiking_pickup = null
