@tool
extends SSPlayer

@onready var coll = $CollisionShape2D

var hud = preload("res://src/mountain/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		Hood.ensure_hud(hud)

	super._ready()

	Debug.pr("mountain player ready")


func get_rect():
	if coll != null:
		return coll.shape.get_rect()
