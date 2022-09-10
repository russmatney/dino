extends StaticBody2D

enum door_state {OPEN, CLOSED}

export(door_state) var state = door_state.CLOSED setget set_door_state

onready var anim: AnimatedSprite = $AnimatedSprite
onready var coll_shape: CollisionShape2D = $CollisionShape2D
onready var action_area: Area2D = $ActionArea

func set_door_state(val):
	state = val

	match state:
		door_state.OPEN:
			if anim:
				anim.animation = "open"
			if coll_shape:
				coll_shape.set_disabled(true)
		door_state.CLOSED:
			if anim:
				anim.animation = "closed"
			if coll_shape:
				print("found coll shape, setting disabled")
				coll_shape.set_disabled(false)
			else:
				print("no coll shape")

func open_door():
	set_door_state(door_state.OPEN)

func close_door():
	set_door_state(door_state.CLOSED)

#######################################################################33
# ready

func _ready():
	if Engine.editor_hint:
		request_ready()

	set_door_state(state)

	print("coll shape disabled", coll_shape.disabled)

#######################################################################33
# actions

var bodies = []

var open_door_action = {
	"func": funcref(self, "open_door"),
	"label": "Open"
	}

var close_door_action = {
	"func": funcref(self, "close_door"),
	"label": "Close"
	}

func _on_ActionArea_body_entered(body:Node):
	bodies.append(body)

	if body.has_method("add_action"):
		match state:
			door_state.OPEN:
				body.add_action(close_door_action)
			door_state.CLOSED:
				body.add_action(open_door_action)


func _on_ActionArea_body_exited(body:Node):
	bodies.erase(body)

	if body.has_method("remove_action"):
		# should no-op ok?
		body.remove_action(close_door_action)
		body.remove_action(open_door_action)
