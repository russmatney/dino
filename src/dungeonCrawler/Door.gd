extends Area2D

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
				coll_shape.disabled = true
		door_state.CLOSED:
			if anim:
				anim.animation = "closed"
			if coll_shape:
				coll_shape.disabled = false

func _ready():
	if Engine.editor_hint:
		request_ready()

	set_door_state(state)

var bodies = []

func _on_ActionArea_body_entered(body:Node):
	bodies.append(body)
	print("[enter] action area bodies", bodies)


func _on_ActionArea_body_exited(body:Node):
	bodies.erase(body)
	print("[exit] action area bodies", bodies)
