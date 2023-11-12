@tool
extends SSPlayer

## warn ##################################################################

func _get_configuration_warnings():
	return super._get_configuration_warnings()

## vars ##################################################################

@export var zoom_rect_min = 200
@export var zoom_margin_min = 100

var hud = preload("res://src/woods/hud/WoodsHUD.tscn")

## ready ##################################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

	super._ready()

## collect ##################################################################

func collect(_entity: WoodsEntity, _opts={}):
	pass
	# match entity.type:
	# 	WoodsEntity.t.Leaf: Log.pr("player collected leaf")
