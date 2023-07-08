extends Node2D

var ingredient_type
var ingredient_data

@onready var anim = $AnimatedSprite2D

func _ready():
	ingredient_data = Spike.all_ingredients.get(ingredient_type)
	if ingredient_data.anim_scene:
		remove_child(anim)
		anim.queue_free()
		anim = ingredient_data.anim_scene.instantiate()
		add_child(anim)

	floaty_tween()

var float_tween

func floaty_tween():
	float_tween = create_tween()
	float_tween.set_loops(0)
	var og_position = position
	var distance = 40.0

	float_tween.tween_property(self, "position", og_position + Vector2.UP * distance, 0.4).set_trans(Tween.TRANS_CUBIC)
	float_tween.tween_property(self, "position", og_position + Vector2.LEFT * distance, 0.4).set_trans(Tween.TRANS_CUBIC)
	float_tween.tween_property(self, "position", og_position + Vector2.DOWN * distance, 0.4).set_trans(Tween.TRANS_CUBIC)
	float_tween.tween_property(self, "position", og_position + Vector2.RIGHT * distance, 0.4).set_trans(Tween.TRANS_CUBIC)
