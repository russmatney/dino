extends RigidBody2D

@onready var anim = $AnimatedSprite2D

var pickup_type

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	Debug.pr("Tossed item body entered: ", body)
	# TODO start combining blobs

	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			if pickup_type:
				body.collect_pickup(pickup_type)
			kill()
	elif body.has_method("take_hit") and not body.is_dead:
		body.take_hit({body=self, damage=1})

# TODO DRY UP against BlobPickup, other 'gathered' items
func kill():
	DJZ.play(DJZ.S.pickup)
	queue_free()

var following
var follow_speed = 20

func gather_pickup(actor):
	following = actor

func _physics_process(delta):
	if following:
		var dist = following.global_position.distance_to(global_position)
		if dist > 10:
			global_position = global_position.lerp(following.global_position, 1 - pow(0.05, delta))
		else:
			global_position = global_position.lerp(following.global_position, 0.5)
