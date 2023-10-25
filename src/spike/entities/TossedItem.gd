extends RigidBody2D

@onready var anim = $AnimatedSprite2D

var ingredient_type
var ingredient_data

func _ready():
	body_entered.connect(_on_body_entered)

	ingredient_data = SpikeData.all_ingredients.get(ingredient_type)
	if ingredient_data.anim_scene:
		remove_child(anim)
		anim.queue_free()
		anim = ingredient_data.anim_scene.instantiate()
		add_child(anim)

func _on_body_entered(body: Node):
	Debug.pr("Tossed item body entered: ", body)

	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			body.collect_pickup(ingredient_type)
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
# cooking pot integration

func can_be_cooked():
	return ingredient_data.can_cook()

func get_ingredient_data():
	return ingredient_data


#############################################################
# delivery integration

func is_delivery():
	return ingredient_data.can_be_delivered()
