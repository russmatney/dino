extends SSWeapon

var aim_vector
# TODO look for aim-point on actor
var toss_offset = Vector2.ONE * -12

func aim(aim_v: Vector2):
	aim_vector = aim_v
	if actor.facing_vector.x < 0:
		rotation = aim_vector.angle() + PI
	else:
		rotation = aim_vector.angle()

func activate():
	if actor:
		actor.notif(str("activated ", self.display_name))
		aim(actor.facing_vector)
	DJZ.play(DJZ.S.laser)

func deactivate():
	pass

func use():
	if not spiking:
		if actor.orbit_items.size() > 0:
			var item = actor.orbit_items[0]
			actor.is_spiking = true
			Log.pr("spiking", item)
			start_spike()
			actor.remove_tossed_orbit_item(item)
	elif spiking:
		toss_item()

func stop_using():
	if spiking:
		toss_item()
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

var spiking = false
var cooldown = 0.2

@onready var tossed_item_scene = preload("res://src/dino/pickups/TossedItem.tscn")

var spiking_ingredient_type
var spike_impulse = 1000

func start_spike():
	Juice.start_slowmo("spike_slowmo", 0.1)
	spiking = true

func toss_item():
	if aim_vector == null:
		aim_vector = actor.move_vector

	var item = tossed_item_scene.instantiate()

	# TODO attach crafting data to tossed item
	# item.ingredient_type = ingredient_type

	item.position = global_position + toss_offset
	item.add_collision_exception_with(actor)

	# TODO emit child for parent/level to add
	U.add_child_to_level(self, item)

	# item.rotation = aim_vector.angle()
	item.apply_impulse(aim_vector * spike_impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)

	Juice.stop_slowmo("spike_slowmo")

	await get_tree().create_timer(cooldown).timeout
	# be sure to remove the collision exception (if it exists), or we can't pick it up again
	if item != null:
		if is_instance_valid(item):
			item.remove_collision_exception_with(actor)

	spiking = false
