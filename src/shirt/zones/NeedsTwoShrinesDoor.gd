@tool
extends Door

func _ready():
	actions = [
		Action.mk({
			fn=func(_actor): open(),
			label="Open",
			source_can_execute=func(): return state == door_state.CLOSED,
			actor_can_execute=func(actor): return actor.has_shrine_gems(2),
			}),
		]
	super._ready()
