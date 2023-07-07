extends SSPlayer

@export var zoom_rect_min = 100
@export var zoom_margin_min = 100

## ready ##################################################################

var hud = preload("res://src/spike/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

	super._ready()

## hotel ##################################################################

# func check_out(data):
# 	super.check_out(data)
# 	shrine_gems = Util.get_(data, "shrine_gems", shrine_gems)

# func hotel_data():
# 	var d = super.hotel_data()
# 	d["shrine_gems"] = shrine_gems
# 	return d
