@tool
extends SSPlayer

var gunner_hud = preload("res://src/gunner/hud/HUD.tscn")
var tower_hud = preload("res://src/tower/hud/HUD.tscn")

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({
			player=self,
			zoom_rect_min=400,
			proximity_min=100,
			proximity_max=450,
			})
		Hood.ensure_hud(gunner_hud)
	super._ready()
