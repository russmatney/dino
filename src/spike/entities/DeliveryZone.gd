extends Node2D

@onready var area = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.has_method("is_delivery") and body.is_delivery():
		Debug.pr("delivered", body)

		Hood.notif("Delivery!")

		# TODO animate delivery
		body.queue_free()
