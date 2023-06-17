@tool
extends TDPlayer

@export var zoom_rect_min = 100
@export var zoom_margin_min = 100

## ready ##################################################################

var hud = preload("res://src/shirt/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

		died.connect(_on_player_death)

	super._ready()

## death #######################################################

func _on_player_death():
	# restart player
	pass

func on_pit_entered():
	machine.transit("Fall")

	await get_tree().create_timer(2.0).timeout
	Game.respawn_player()
