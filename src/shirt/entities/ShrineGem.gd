extends Pickup

func _ready():
	actions = [
		Action.mk({label="Pickup Shrine Gem",
			fn=func(actor):
			actor.add_shrine_gem()
			fade_out()
			})
		]

	super._ready()
