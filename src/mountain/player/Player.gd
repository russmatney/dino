@tool
extends SSPlayer

@onready var warp_cast = $WarpCast


## ready ##################################################################

var hud = preload("res://src/mountain/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self,
			# zoom_rect_min=200,
			# zoom_margin_min=120,
			})
		Hood.ensure_hud(hud)
	actions = _actions
	super._ready()

	notif("[jump]Ready[/jump]")


## actions ##################################################################

var _actions = [
	# Action.mk({label="Ascend",
	# 	fn=func(player): player.machine.transit("Ascend"),
	# 	actor_can_execute=func(p): return not p.is_dead,
	# 	}),
	# Action.mk({label="Descend",
	# 	fn=func(player): player.machine.transit("Descend"),
	# 	actor_can_execute=func(p): return not p.is_dead,
	# 	})
	]
