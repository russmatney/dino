@tool
extends Node2D

var anim
@onready var pickup_box = $Area2D
@export var ingredient_type: SpikeData.Ingredient = SpikeData.Ingredient.GreyBlob

var ingredient_data

func _ready():
	pickup_box.body_entered.connect(_on_body_entered)

	ingredient_data = SpikeData.all_ingredients.get(ingredient_type)
	if ingredient_data.anim_scene:
		anim = ingredient_data.anim_scene.instantiate()
		add_child(anim)

	floaty_tween()

var float_tween

func floaty_tween():
	float_tween = create_tween()
	float_tween.set_loops(0)
	var og_position = position

	float_tween.tween_property(self, "position", og_position + Vector2.UP * 5.0, 0.4).set_trans(Tween.TRANS_BOUNCE)
	float_tween.tween_property(self, "position", og_position, 0.3).set_trans(Tween.TRANS_BOUNCE)

func kill():
	DJZ.play(DJZ.S.pickup)
	queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			Debug.pr("collecting ingredient type", ingredient_type)
			# pass ingredient data along
			body.collect_pickup(ingredient_type)
			kill()

var following
var follow_speed = 20

func gather_pickup(actor):
	following = actor

func _physics_process(delta):
	if following:
		if float_tween and float_tween.is_running():
			float_tween.kill()
		var dist = following.global_position.distance_to(global_position)
		if dist > 10:
			global_position = global_position.lerp(following.global_position, 1 - pow(0.05, delta))
		else:
			global_position = global_position.lerp(following.global_position, 0.5)
