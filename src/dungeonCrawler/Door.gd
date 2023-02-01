extends StaticBody2D

enum door_state { LOCKED, OPEN, CLOSED }

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
				coll_shape.set_disabled(false)
		door_state.LOCKED:
			if anim:
				anim.animation = "closed"  # TODO support "locked"
			if coll_shape:
				coll_shape.set_disabled(false)


func open_door(_body = null):
	set_door_state(door_state.OPEN)
	# it'd be better to attach this to the actions magically
	# maybe actions should get pre/post hooks
	# starting to feel state machiney
	update_bodies()


func close_door(_body = null):
	set_door_state(door_state.CLOSED)
	update_bodies()


func unlock_door(body = null):
	set_door_state(door_state.CLOSED)

	# this.... this is crazy, right?
	if body and body.has_method("use_key"):
		body.use_key()

	update_bodies()


func lock_door(_body = null):
	set_door_state(door_state.LOCKED)
	update_bodies()


func jostle_door(_body = null):
	# TODO some animation/something
	print("jostling the door!")
	update_bodies()


#######################################################################33
# ready


func _ready():
	if Engine.editor_hint:
		request_ready()

	# make sure any setup code is called so we're in the expected state
	set_door_state(state)


#######################################################################33
# actions

var bodies = []

var unlock_door_action = {"func": funcref(self, "unlock_door"), "label": "Unlock"}

var lock_door_action = {"func": funcref(self, "lock_door"), "label": "lock"}

var open_door_action = {"func": funcref(self, "open_door"), "label": "Open"}

var close_door_action = {"func": funcref(self, "close_door"), "label": "Close"}

var door_locked_message = {"func": funcref(self, "jostle_door"), "label": "(locked)"}


func remove_actions(body):
	if body.has_method("remove_action"):
		# should no-op ok?
		body.remove_action(close_door_action)
		body.remove_action(open_door_action)
		body.remove_action(lock_door_action)
		body.remove_action(unlock_door_action)
		body.remove_action(door_locked_message)


func update_body(body):
	remove_actions(body)
	if body.has_method("add_action"):
		match state:
			door_state.OPEN:
				body.add_action(close_door_action)
				if body.has_method("can_lock_door"):
					if body.can_lock_door():
						body.add_action(lock_door_action)
			door_state.CLOSED:
				body.add_action(open_door_action)
				if body.has_method("can_lock_door"):
					if body.can_lock_door():
						body.add_action(lock_door_action)
			door_state.LOCKED:
				if body.has_method("can_unlock_door"):
					# TODO pass params to support key vs boss key
					# or do that logic here
					if body.can_unlock_door():
						body.add_action(unlock_door_action)
					else:
						print("player cannot unlock door!")
						body.add_action(door_locked_message)
						# todo should this all be via emit/sub??
						# it seems like it'd be nicer, but we'd
						# have to manage the connections
						# perhaps an event/routing system could reduce that?


# update actions on all bodies we're currently aware of
# TODO move into `AXE` helper namespace/dino lib
func update_bodies():
	print("[Door ", self.name, " bodies]: ", bodies)
	for body in bodies:
		update_body(body)


func _on_ActionArea_body_entered(body: Node):
	bodies.append(body)
	update_bodies()


func _on_ActionArea_body_exited(body: Node):
	bodies.erase(body)
	remove_actions(body)
