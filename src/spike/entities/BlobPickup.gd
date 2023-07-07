@tool
extends Node2D

@onready var pickup_box = $Area2D
var pickup_type = "blob"

var picked_up = false

func _ready():
	pickup_box.body_entered.connect(_on_body_entered)

	floaty_tween()

var float_tween

func floaty_tween():
	float_tween = create_tween()
	float_tween.set_loops(0)
	var og_position = position

	float_tween.tween_property(self, "position", og_position + Vector2.UP * 5.0, 0.4).set_trans(Tween.TRANS_BOUNCE)
	float_tween.tween_property(self, "position", og_position, 0.3).set_trans(Tween.TRANS_BOUNCE)

func kill():
	DJZ.play(DJZ.S.pickup)
	# TODO animate
	queue_free()

func _on_body_entered(body: Node):
	if not picked_up:
		if body.is_in_group("player"):
			if body.has_method("collect_pickup"):
				if pickup_type:
					body.collect_pickup(pickup_type)
					picked_up = true
				kill()

var following
var follow_speed = 20

func gather_pickup(actor):
	following = actor

func _physics_process(delta):
	if following:
		if float_tween and float_tween.is_running():
			float_tween.kill()
		var dist = following.global_position.distance_to(global_position)
		if dist > 10:
			global_position = global_position.lerp(following.global_position, 1 - pow(0.05, delta))
		else:
			global_position = global_position.lerp(following.global_position, 0.5)
