extends StaticBody2D

enum door_state {LOCKED, OPEN, CLOSED}

export(door_state) var state = door_state.CLOSED setget set_door_state

onready var anim: AnimatedSprite = $AnimatedSprite
onready var coll_shape: CollisionShape2D = $CollisionShape2D
onready var action_area: Area2D = $ActionArea

func set_door_state(val):
	state = val

	match state:
		door_state.OPEN:
			anim.animation = "open"
			coll_shape.set_disabled(true)
		door_state.CLOSED:
			anim.animation = "closed"
			coll_shape.set_disabled(false)
		door_state.LOCKED:
			anim.animation = "closed" # TODO support "locked"
			coll_shape.set_disabled(false)

func open_door():
	set_door_state(door_state.OPEN)

func close_door():
	set_door_state(door_state.CLOSED)

func unlock_door():
	set_door_state(door_state.CLOSED)

func lock_door():
	set_door_state(door_state.LOCKED)


#######################################################################33
# ready

func _ready():
	if Engine.editor_hint:
		request_ready()

	set_door_state(state)

#######################################################################33
# actions

var bodies = []

var unlock_door_action = {
	"func": funcref(self, "unlock_door"),
	"label": "Unlock"
	}

var lock_door_action = {
	"func": funcref(self, "lock_door"),
	"label": "lock"
	}

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
				body.add_action(lock_door_action)
			door_state.CLOSED:
				body.add_action(open_door_action)
				body.add_action(lock_door_action)
			door_state.LOCKED:
				body.add_action(unlock_door_action)


func _on_ActionArea_body_exited(body:Node):
	bodies.erase(body)

	if body.has_method("remove_action"):
		# should no-op ok?
		body.remove_action(close_door_action)
		body.remove_action(open_door_action)
		body.remove_action(lock_door_action)
		body.remove_action(unlock_door_action)
