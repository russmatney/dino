@tool
extends TDPlayer

var shrine_gems = 0

## ready ##################################################################

@export var zoom_rect_min = 100
@export var zoom_margin_min = 100

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
	super._ready()

## death #######################################################

func on_pit_entered():
	machine.transit("Fall")

	await get_tree().create_timer(1.0).timeout
	P.respawn_player()

## shrine_gems #######################################################

func has_shrine_gems(n):
	return shrine_gems >= n

func add_shrine_gem():
	shrine_gems += 1
