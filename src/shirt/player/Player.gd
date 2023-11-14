@tool
extends TDPlayer

@export var zoom_rect_min = 100
@export var zoom_margin_min = 100

var shrine_gems = 0

## ready ##################################################################

var hud = preload("res://src/shirt/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

		died.connect(_on_player_death)

	super._ready()

## hotel ##################################################################

func check_out(data):
	super.check_out(data)
	shrine_gems = U.get_(data, "shrine_gems", shrine_gems)

func hotel_data():
	var d = super.hotel_data()
	d["shrine_gems"] = shrine_gems
	return d

## death #######################################################

func _on_player_death():
	# restart player
	pass

func on_pit_entered():
	machine.transit("Fall")

	await get_tree().create_timer(1.0).timeout
	P.respawn_player()

## shrine_gems #######################################################

func has_shrine_gems(n):
	return shrine_gems >= n

func add_shrine_gem():
	shrine_gems += 1
	Hotel.check_in(self)
