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
		Action.mk({
			label="Not enough shrine gems",
			input_action="",
			source_can_execute=func(): return state == door_state.CLOSED,
			actor_can_execute=func(actor): return actor.has_shrine_gems(1) or actor.has_shrine_gems(0),
			}),
		]
	super._ready()
