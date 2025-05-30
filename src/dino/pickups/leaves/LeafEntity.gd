@tool
extends WoodsEntity


## vars ###########################################################

@onready var anim_green = $Green
@onready var anim_greenred = $GreenRed
@onready var anim_purple = $Purple
@onready var anim_redorange = $RedOrange
@onready var anim_yellow = $Yellow

func all_anims() -> Array:
	return [anim_green, anim_greenred, anim_purple, anim_redorange, anim_yellow]

signal caught(leaf)
var is_caught = false

var anim

func _ready():
	hide_anims()
	anim = U.rand_of(all_anims())
	super._ready()
	render()
	OffscreenIndicator.add(self, {label="Leaf"})

func hide_anims():
	all_anims().map(func(a):
		if a != null:
			a.set_visible(false))
	if anim_yellow != null:
		anim_yellow.set_visible(false)

## render ###########################################################

func render():
	if anim != null:
		anim.set_visible(true)
		anim.play("twist")

func kill():
	is_caught = true
	caught.emit(self)
	animate_collected()
	Sounds.play(Sounds.S.playerheal)

func animate_collected():
	var time = 0.4
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 0.5, time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position", position - Vector2.ONE * 10, time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_callback(queue_free)

## on_collect_box_entered ###########################################################

func on_collect_box_entered(body):
	if body.is_in_group("player"):
		if body.has_method("collect"):
			# TODO improve this drop/pickup api
			body.collect({body=self, data=DropData.new(DropData.T.LEAF)})
			kill()
