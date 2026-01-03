@tool
extends SSWeapon

var aim_vector
# TODO look for aim-point on actor
var toss_offset = Vector2.ONE * -12

var spiked_item

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
	Sounds.play(Sounds.S.laser)

func deactivate():
	pass

func use():
	if spiked_item == null:
		if actor.orbit_items.size() > 0:
			start_spike_slowmo(actor.orbit_items[0])
	else:
		toss_item()

func stop_using():
	if spiked_item:
		actor.remove_tossed_orbit_item.call_deferred(spiked_item)
		toss_item()

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

var cooldown = 0.2

@onready var tossed_item_scene = preload("res://src/dino/pickups/TossedItem.tscn")

var spike_impulse = 1000

func start_spike_slowmo(item):
	Juice.start_slowmo("spike_slowmo", 0.1)
	spiked_item = item

func toss_item():
	if aim_vector == null:
		aim_vector = actor.move_vector

	var item = tossed_item_scene.instantiate()

	# attach data to tossed item
	item.drop_data = spiked_item.drop_data

	item.position = global_position + toss_offset
	item.add_collision_exception_with(actor)

	U.add_child_to_level(self, item)

	# item.rotation = aim_vector.angle()
	item.apply_impulse(aim_vector * spike_impulse, Vector2.ZERO)
	Sounds.play(Sounds.S.fire)

	Juice.stop_slowmo("spike_slowmo")

	U.call_in(actor, item.enable_monitoring, cooldown)

	await get_tree().create_timer(cooldown).timeout

	spiked_item = null
