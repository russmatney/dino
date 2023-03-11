@tool
extends Node2D

@onready var collision_shape = $AnimatableBody2D/CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var action_area = $ActionArea

##################################################################
# actions

var actions = [
	Action.mk({
		label="Open", fn=open, source_can_execute=can_open,
		}),
	Action.mk({
		label="Close", fn=close, source_can_execute=can_close,
		})
	]

##################################################################
# exports

@export var state = "closed" :
	set(new_state):
		if state != new_state:
			state = new_state
			update_state()

func update_state():
	if state == "open":
		open()
	elif state == "closed":
		close()

##################################################################
# ready

func _ready():
	Hotel.register(self)

	action_area.register_actions(actions, self)

	update_state()
	anim.animation_finished.connect(_on_animation_finished)

func hotel_data():
	return {state=state}
func check_out(data):
	state = data.get("state", state)

func _on_animation_finished():
	if anim.animation == "opening":
		anim.play("open")
		if collision_shape:
			collision_shape.call_deferred("set_disabled", true)
	elif anim.animation == "closing":
		anim.play("closed")
		collision_shape.call_deferred("set_disabled", false)

##################################################################
# open/close

func open():
	state = "open"
	if anim:
		anim.play("opening")


func close():
	state = "closed"
	if anim:
		anim.play("closing")

##################################################################
# can

func can_open():
	return state == "closed"

func can_close():
	return state == "open"
