@tool
extends SSPlayer

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({
			player=self,
			zoom_rect_min=400,
			proximity_min=100,
			proximity_max=450,
			})

	has_gun = true
	has_boomerang = true
	has_double_jump = true

	# has_climb = true
	# has_jetpack = true
	# has_dash = false

	super._ready()

## collect ##################################################################

# TODO promote to SSPlayer so other players can do this
func collect(_entity, _opts={}):
	pass
	# match entity.type:
	# 	WoodsEntity.t.Leaf: Log.pr("player collected leaf")

# TODO pull in spike's orbiting items bit, promote so other players can use it
