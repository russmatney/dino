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

var anim

func _ready():
	hide_anims()
	anim = Util.rand_of(all_anims())
	super._ready()
	render()

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
