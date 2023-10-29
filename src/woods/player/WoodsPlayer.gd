@tool
extends SSPlayer

func _get_configuration_warnings():
	return super._get_configuration_warnings()

@export var zoom_rect_min = 200
@export var zoom_margin_min = 100

## ready ##################################################################

var hud = preload("res://src/woods/hud/WoodsHUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

	super._ready()

## collect ##################################################################

func collect(entity: WoodsEntity, _opts={}):
	match entity.type:
		WoodsEntity.t.Leaf: Debug.pr("player collected leaf")

## reach end ##################################################################

func entered_end_box():
	Debug.pr("Player entered end box!")

	var cs = Navi.current_scene
	if cs.has_method("generate"):
		Debug.pr("quick n dirty replay")
		cs.generate()
		Game.respawn_player()
		return
