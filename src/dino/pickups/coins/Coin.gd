extends Node2D

## vars #########################################################

@onready var anim = $AnimatedSprite2D
@onready var light = $PointLight2D

signal on_collected(coin)
var collected = false

## ready #########################################################

func _ready():
	Hotel.register(self)

## hotel #########################################################

func hotel_data():
	return {collected=collected}

func check_out(data):
	collected = data.get("collected", collected)
	if collected:
		disable()

## body entered #########################################################

func _on_Area2D_body_entered(body: Node):
	if collected:
		return

	if body.is_in_group("player"):
		if body.has_method("collect"):
			# TODO improve this drop/pickup api
			body.collect({body=self, data=DropData.new(DropData.T.COIN)})

			Sounds.play(Sounds.S.coin)
			collected = true
			on_collected.emit(self)
			disable()
			Hotel.check_in(self)

## disable #########################################################

func disable():
	anim.set_visible(false)
	light.set_visible(false)
