extends Node2D

var drop_data

func _ready():
	if drop_data:
		drop_data.add_anim_scene(self)
	else:
		Log.warn("loading orbit item without drop data!", self)

	floaty_tween()

var float_tween

func floaty_tween():
	float_tween = create_tween()
	float_tween.set_loops(0)
	var og_position = position
	var distance = 20.0

	float_tween.tween_property(self, "position", og_position + Vector2.UP * distance, 0.3).set_trans(Tween.TRANS_CUBIC)
	float_tween.tween_property(self, "position", og_position + Vector2.LEFT * distance, 0.3).set_trans(Tween.TRANS_CUBIC)
	float_tween.tween_property(self, "position", og_position + Vector2.DOWN * distance, 0.3)
	float_tween.tween_property(self, "position", og_position + Vector2.RIGHT * distance, 0.3)
