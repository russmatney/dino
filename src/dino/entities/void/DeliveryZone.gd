extends Node2D

@onready var area = $Area2D
@onready var label = $Label

@export var expected_delivery_count = 1
var delivery_count = 0

var complete = false

signal void_satisfied(x)

func _ready():
	area.body_entered.connect(_on_body_entered)
	label.text = "[center]VOID WANT ORB[/center]"

var spike_impulse = 1000

func _on_body_entered(body: Node):
	if body.has_method("is_delivery") and body.is_delivery():
		if not complete:
			delivery_count += 1

			if delivery_count >= expected_delivery_count:
				complete = true
				void_satisfied.emit(self)
				Debug.notif("VOID SATISFIED!")
				label.text = "[center]VOID SATISFIED[/center]"

			# consume the orb
			body.queue_free()
		else:
			if complete:
				Debug.notif("VOID FULL!")
			else:
				Debug.notif("THIS IS NOT MY ORDER!")
			# double reversed linear_velocity
			body.apply_impulse(body.linear_velocity.normalized() * Vector2(-1, 1.1) * spike_impulse * 2, Vector2.ZERO)
