extends RigidBody2D

var drop_data: DropData

func _ready():
	body_entered.connect(_on_body_entered)

	if drop_data:
		drop_data.add_anim_scene(self)
	else:
		Log.warn("tossed item has no drop data!")

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect"):
			body.collect({body=self, data=drop_data})
			kill()
	elif body.has_method("take_hit") and not body.is_dead:
		body.take_hit({body=self, damage=1})

func kill():
	DJZ.play(DJZ.S.pickup)
	queue_free()

#############################################################
# supports boomerang-style pickup

func gather_pickup(actor):
	following = actor

#############################################################
# following impl

var following
var follow_speed = 20

func _physics_process(delta):
	if following:
		var dist = following.global_position.distance_to(global_position)
		if dist > 10:
			global_position = global_position.lerp(following.global_position, 1 - pow(0.05, delta))
		else:
			global_position = global_position.lerp(following.global_position, 0.5)

#############################################################
# crafting/data integration
# TODO express via drop/crafting/item data?

func can_be_cooked():
	return true

func get_data():
	return drop_data

func is_delivery():
	return true
