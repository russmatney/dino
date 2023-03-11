extends Node2D

@onready var anim = $AnimatedSprite2D

func _ready():
	Hotel.register(self)

signal on_collected(coin)
var collected = false

func hotel_data():
	return {collected=collected}

func check_out(data):
	collected = data.get("collected", collected)
	if collected:
		disable()

func _on_Area2D_body_entered(body: Node):
	if collected:
		return

	Debug.prn("coin body entered", body)
	if body.has_method("add_coin"):
		body.add_coin()
		# TODO coin noise
		collected = true
		on_collected.emit(self)
		disable()
		Hotel.check_in(self)

func disable():
	anim.set_visible(false)
