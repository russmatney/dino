extends SSWeapon

var aim_vector
var toss_offset = Vector2.ONE * -12

func aim(aim_v: Vector2):
	aim_vector = aim_v
	if actor.facing_vector.x < 0:
		rotation = aim_vector.angle() + PI
	else:
		rotation = aim_vector.angle()

func activate():
	Debug.pr("activating", self)
	actor.notif(str("activated ", self.display_name))
	DJZ.play(DJZ.S.laser)
	aim(actor.facing_vector)

func deactivate():
	pass

func use():
	if not tossing and not spiking:
		if actor.orbit_items.size() > 0:
			var item = actor.orbit_items[0]
			if actor.in_spike_zone():
				actor.is_spiking = true
				start_spike(item.ingredient_type)
			else:
				toss(item.ingredient_type)
			actor.remove_orbit_item(item)
	elif spiking:
		if spiking_ingredient_type != null:
			stop_using()
		else:
			do_spike(null)

func stop_using():
	Debug.pr("stop using orbit item")
	if spiking and spiking_ingredient_type != null:
		do_spike(spiking_ingredient_type)
		actor.is_spiking = false

######################################################
# ready

func _ready():
	super._ready()
	display_name = "Orbs"

func _on_animation_finished():
	pass

func _on_frame_changed():
	pass

######################################################
# actions

var tossing = false
var spiking = false
var cooldown = 0.2

@onready var tossed_item_scene = preload("res://src/spike/entities/TossedItem.tscn")
var toss_impulse = 300
var knockback = 1

func toss(ingredient_type):
	Debug.pr("tossing ingredient_type:", ingredient_type)
	tossing = true

	if aim_vector == null:
		aim_vector = actor.move_vector

	var item = tossed_item_scene.instantiate()
	item.ingredient_type = ingredient_type
	item.position = global_position + toss_offset
	item.add_collision_exception_with(actor)


	Navi.add_child_to_current(item)
	# item.rotation = aim_vector.angle()
	item.apply_impulse(aim_vector * toss_impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)

	await get_tree().create_timer(cooldown).timeout
	# be sure to remove the collision exception, or we can't pick it up again
	if is_instance_valid(item):
		item.remove_collision_exception_with(actor)
	tossing = false

var spiking_ingredient_type
var spike_impulse = 1000

func start_spike(ingredient_type):
	spiking_ingredient_type = ingredient_type
	Cam.start_slowmo("spike_slowmo", 0.1)
	Debug.pr("start spike ingredient_type:", ingredient_type)
	spiking = true

func do_spike(ingredient_type):
	Debug.pr("do spike ingredient_type:", ingredient_type)

	if aim_vector == null:
		aim_vector = actor.move_vector

	var item
	if ingredient_type != null:
		item = tossed_item_scene.instantiate()
		item.ingredient_type = ingredient_type
		item.position = global_position + toss_offset
		item.add_collision_exception_with(actor)

		Navi.add_child_to_current(item)
		# item.rotation = aim_vector.angle()
		item.apply_impulse(aim_vector * spike_impulse, Vector2.ZERO)
		DJZ.play(DJZ.S.fire)

	Cam.stop_slowmo("spike_slowmo")

	await get_tree().create_timer(cooldown).timeout
	# be sure to remove the collision exception (if it exists), or we can't pick it up again
	if item != null:
		if is_instance_valid(item):
			item.remove_collision_exception_with(actor)
	spiking = false
	spiking_ingredient_type = null
