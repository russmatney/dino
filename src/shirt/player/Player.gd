@tool
extends TDPlayer

## ready ##################################################################

var hud = preload("res://src/shirt/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self})
		Hood.ensure_hud(hud)

		died.connect(_on_player_death)

	super._ready()

## death #######################################################

func _on_player_death():
	# restart player
	pass
