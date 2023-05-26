@tool
extends SSPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint
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
	super._ready()

	has_double_jump = true
	has_climb = true

	if not Engine.is_editor_hint():
		# TODO could we just Actions.register(self) or Trolley.register(self)?
		# include opting into keybindings and current-ax updates
		action_detector.setup(self, {actions=actions, action_hint=action_hint,
			can_execute_any=func(): return not machine.state.name in ["Rest"]})


## actions ##################################################################

var actions = [
	# Action.mk({label="Ascend",
	# 	fn=func(player): player.machine.transit("Ascend"),
	# 	actor_can_execute=func(p): return not p.is_dead,
	# 	}),
	# Action.mk({label="Descend",
	# 	fn=func(player): player.machine.transit("Descend"),
	# 	actor_can_execute=func(p): return not p.is_dead,
	# 	})
	]


## input ##################################################################

func _unhandled_input(event):
	if Trolley.is_action(event):
		action_detector.execute_current_action()
		action_detector.current_action()

	if Trolley.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_prev_action()
	elif Trolley.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_next_action()
