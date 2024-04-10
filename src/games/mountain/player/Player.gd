@tool
extends SSPlayer

## ready ##################################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self,
			# zoom_rect_min=200,
			# zoom_margin_min=120,
			})
	super._ready()
