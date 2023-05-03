extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var aa = $ActionArea
@onready var action_hint = $ActionHint

var max_health = 6
var health = 6

###########################################################
# enter tree

func _enter_tree():
	Hotel.book(self)

###########################################################
# ready

func _ready():
	Hotel.register(self)
	machine.start()
	Cam.add_offscreen_indicator(self)

	aa.register_actions(actions, {source=self, action_hint=action_hint})

	# BulletUpHell global signal
	Spawning.bullet_collided_body.connect(_on_bullet_collided)

######################################################
# hotel

func hotel_data():
	return {health=health}

func check_out(data):
	health = Util.get_(data, "health", health)

###########################################################

var actions = [
	Action.mk({
		label_fn=func(): return str("Call ", name),
		fn=called_by_player,
		source_can_execute=func(): return following == null and grabbed_by == null,
		}),
	Action.mk({
		label_fn=func(): return str("Grab ", name),
		fn=grabbed_by_player,
		maximum_distance=50.0,
		source_can_execute=func(): return following != null,
		actor_can_execute=func(player): return following == player and player.can_grab(),
		}),
	Action.mk({
		label_fn=func(): return str("Throw ", name),
		fn=thrown_by_player,
		source_can_execute=func(): return grabbed_by != null,
		actor_can_execute=func(player): return player.grabbing == self,
		})
	]

var following
var grabbed_by

func called_by_player(player):
	Debug.pr(name, "called by player", player)
	following = player
	machine.transit("Follow")

func grabbed_by_player(player):
	Debug.pr(name, "grabbed by player", player)
	player.grab(self)
	grabbed_by = player
	machine.transit("Grabbed")

func thrown_by_player(player):
	Debug.pr(name, "thrown by player", player)
	var opts = player.throw(self)
	if opts != null:
		machine.transit("Thrown", {
			direction=opts.get("direction", Vector2.LEFT),
			throw_speed=opts.get("throw_speed")
			})

######################################################
# bullets

func _on_bullet_collided(
		body:Node, _body_shape_index:int, _bullet:Dictionary,
		_local_shape_index:int, _shared_area:Area2D
	):
	if body == self:
		bullet_hit()

func bullet_hit():
	health -= 1
	Hotel.check_in(self)
	Cam.screenshake(0.3)

	health = clamp(health, 0, max_health)

	if health <= 0:
		machine.transit("Die")
	else:
		machine.transit("Hit")
