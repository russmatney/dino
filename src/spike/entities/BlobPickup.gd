@tool
extends Node2D

@onready var pickup_box = $Area2D
var pickup_type = "blob"

func _ready():
	pickup_box.body_entered.connect(_on_body_entered)


	floaty_tween()

func floaty_tween():
	var t = create_tween()
	t.set_loops(0)
	var og_position = position

	t.tween_property(self, "position", og_position + Vector2.UP * 5.0, 0.4).set_trans(Tween.TRANS_BOUNCE)
	t.tween_property(self, "position", og_position, 0.3).set_trans(Tween.TRANS_BOUNCE)

func kill():
	DJZ.play(DJZ.S.pickup)
	# TODO animate
	queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			if pickup_type:
				body.collect_pickup(pickup_type)
			kill()
