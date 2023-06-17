@tool
extends Node2D
class_name Door

@onready var anim = $AnimatedSprite2D
@onready var body = $StaticBody2D
@onready var action_area = $ActionArea

enum door_state {CLOSED, OPEN}

@export var state = door_state.CLOSED : set = update_door

var actions = [
	Action.mk({fn=func(_actor): open(), label="Open", source_can_execute=func(): return state == door_state.CLOSED}),
	Action.mk({fn=func(_actor): close(), label="Close", source_can_execute=func(): return state == door_state.OPEN}),
	]

func _ready():
	anim.animation_finished.connect(on_anim_finished)
	update_door()

	action_area.register_actions(actions, {source=self})


func on_anim_finished():
	if anim.animation == "closing":
		anim.play("closed")
	if anim.animation == "opening":
		anim.play("open")
		body.set_collision_layer_value(1, false)


func update_door(new_state=null):
	if new_state != null:
		state = new_state
	# ugh, support setget before _ready
	if not anim or not body:
		return
	if state == door_state.CLOSED:
		if not anim.animation in ["closed", "closing"]:
			anim.play("closing")
		body.set_collision_layer_value(1, true)
	if state == door_state.OPEN:
		if not anim.animation in ["open", "opening"]:
			anim.play("opening")

func open():
	update_door(door_state.OPEN)

func close():
	update_door(door_state.CLOSED)
