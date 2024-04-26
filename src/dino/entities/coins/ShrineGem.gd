extends Node2D

## vars #########################################################

@onready var anim = $AnimatedSprite2D

var picked_up = false

## ready #########################################################

func _ready():
	anim.animation_finished.connect(func():
		if anim.animation == "shine":
			anim.play("gem"))

	var t = create_tween()
	t.set_loops()
	t.tween_callback(anim.play.bind("shine")).set_delay(3)

## actions #########################################################

var actions = [
	Action.mk({label="Pickup Shrine Gem",
		source_can_execute=func(): return picked_up == false,
		fn=collect,
		})
	]

func collect(actor):
	actor.collect({body=self, data=DropData.new(DropData.T.GEM)})
	fade_out()

## fade #########################################################

func fade_out():
	picked_up = true
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 1)
	t.tween_callback(self.queue_free)

