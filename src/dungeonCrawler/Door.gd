extends StaticBody2D

enum door_state { LOCKED, OPEN, CLOSED }

@export var state: door_state = door_state.CLOSED : set = set_door_state

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var coll_shape: CollisionShape2D = $CollisionShape2D
@onready var action_area: Area2D = $ActionArea


#######################################################################33
# ready

var actions = [
	Action.mk({label="Open", fn=open_door,
		source_can_execute=func(): return state == door_state.CLOSED}),
	Action.mk({label="Close", fn=close_door,
		source_can_execute=func(): return state == door_state.OPEN}),
	Action.mk({label="Unlock", fn=unlock_door,
		source_can_execute=func(): return state == door_state.LOCKED,
		actor_can_execute=func(actor):
		if actor.has_method("can_unlock_door"):
			return actor.can_unlock_door()
		}),
	Action.mk({label="Jostle", fn=jostle_door,
		source_can_execute=func(): return state == door_state.LOCKED,
		actor_can_execute=func(actor):
		if actor.has_method("can_unlock_door"):
			return not actor.can_unlock_door()
		return true
		})
	]

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	action_area.register_actions(actions, {source=self})

	# make sure any setup code is called so we're in the expected state
	set_door_state(state)


#######################################################################33
# door state

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
				coll_shape.set_disabled(false)
		door_state.LOCKED:
			if anim:
				anim.animation = "closed"
			if coll_shape:
				coll_shape.set_disabled(false)


func open_door(_actor):
	set_door_state(door_state.OPEN)


func close_door(_actor):
	set_door_state(door_state.CLOSED)


func unlock_door(actor):
	set_door_state(door_state.CLOSED)
	if actor and actor.has_method("use_key"):
		actor.use_key()


func lock_door(_body = null):
	set_door_state(door_state.LOCKED)


func jostle_door(_body = null):
	Cam.screenshake(0.3)
