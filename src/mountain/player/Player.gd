@tool
extends SSPlayer

var hud = preload("res://src/mountain/hud/HUD.tscn")

func _ready():
	super._ready()
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		Hood.ensure_hud(hud)
