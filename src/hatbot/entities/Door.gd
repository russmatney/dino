@tool
extends Node2D

@onready var collision_shape = $AnimatableBody2D/CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var front_action_area = $FrontActionArea
@onready var back_action_area = $BackActionArea
@onready var cam_pof = $CamPOF

##################################################################
# actions

var front_actions = []
var back_actions = [
	Action.mk({
		label="Open", fn=open, source_can_execute=can_open,
		}),
	# Action.mk({
	# 	label="Close", fn=close, source_can_execute=can_close,
	# 	})
	]

##################################################################
# exports

@export var state = "closed" :
	set(new_state):
		if state != new_state:
			state = new_state
			update_state()

func update_state():
	if is_open():
		open()
	elif is_closed():
		close()

##################################################################
# ready

func _ready():
	Hotel.register(self)

	front_action_area.register_actions(front_actions, self)
	back_action_area.register_actions(back_actions, self)

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
		cam_pof.deactivate()

	elif anim.animation == "closing":
		anim.play("closed")
		collision_shape.call_deferred("set_disabled", false)
		cam_pof.deactivate()

##################################################################
# on_room_entered

func on_room_entered():
	# replay anims to get anim-finished side effects (cam-pof deactivate)
	update_state()

##################################################################
# open/close

func open(_actor=null):
	state = "open"
	if anim:
		anim.play("opening")
		cam_pof.activate()


func close(_actor=null):
	state = "closed"
	if anim:
		anim.play("closing")
		cam_pof.activate()

##################################################################
# is

func is_open():
	return state == "open"

func is_closed():
	return state == "closed"

##################################################################
# can

func can_open():
	return is_closed()

func can_close():
	return is_open()