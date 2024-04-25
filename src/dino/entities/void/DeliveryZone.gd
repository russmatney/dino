extends Node2D

@onready var area = $Area2D
@onready var label = $Label

@export var expected_delivery_type: SpikeData.Ingredient = SpikeData.Ingredient.RedBlob
@export var expected_delivery_count = 1
var delivery_count = 0

var complete = false

signal void_satisfied

func _ready():
	area.body_entered.connect(_on_body_entered)
	var ing_data = SpikeData.all_ingredients[expected_delivery_type]
	label.text = "[center]VOID WANT %s ORB[/center]" % ing_data.display_type

var spike_impulse = 1000

func _on_body_entered(body: Node):
	if body.has_method("is_delivery") and body.is_delivery():
		if not complete and body.ingredient_type == expected_delivery_type:
			delivery_count += 1

			if delivery_count >= expected_delivery_count:
				complete = true
				void_satisfied.emit()
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
