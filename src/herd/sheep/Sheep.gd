extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var action_area = $ActionArea
@onready var action_hint = $ActionHint

var max_health = 3
var health = 3

###########################################################
# enter tree

func _enter_tree():
	Hotel.book(self)

###########################################################
# ready

func _ready():
	Hotel.register(self)
	machine.start()
	Cam.add_offscreen_indicator(self, {label="Sheep"})

	action_area.register_actions(actions, {source=self, action_hint=action_hint})

	# BulletUpHell global signal
	Spawning.bullet_collided_body.connect(_on_bullet_collided)

######################################################
# hotel

func hotel_data():
	return {health=health, is_dead=is_dead}

func check_out(_data):
	# reset sheep to full health for now
	# health = Util.get_(data, "health", health)
	pass

###########################################################

var actions = [
	Action.mk({
		label="Call",
		fn=follow_player,
		source_can_execute=func():
		return following == null and grabbed_by == null and not machine.state.name in ["Thrown"] and not is_dead,
		}),
	Action.mk({
		label="Grab",
		fn=grabbed_by_player,
		maximum_distance=50.0,
		source_can_execute=func(): return following != null,
		actor_can_execute=func(player):
		return \
		# player not moving
		player.input_move_dir.length() <= 0.1 \
		and following == player and player.can_grab() and not is_dead,
		}),
	Action.mk({
		label="Throw",
		fn=thrown_by_player,
		source_can_execute=func(): return grabbed_by != null,
		actor_can_execute=func(player): return player.grabbing == self and not is_dead,
		})
	]

var following
var grabbed_by

func follow_player(player):
	Util._connect(player.dying, on_player_dying)
	following = player
	machine.transit("Follow")

func grabbed_by_player(player):
	Util._connect(player.dying, on_player_dying)
	player.grab(self)
	grabbed_by = player
	machine.transit("Grabbed")

func thrown_by_player(player):
	var opts = player.throw(self)
	if opts != null:
		machine.transit("Thrown", {
			direction=opts.get("direction", Vector2.LEFT),
			throw_speed=opts.get("throw_speed")
			})

func on_player_dying(_player):
	following = null
	grabbed_by = null

######################################################
# bullets

func _on_bullet_collided(
		body:Node, _body_shape_index:int, _bullet:Dictionary,
		_local_shape_index:int, _shared_area:Area2D
	):
	if Herd.level_complete:
		return
	if body == self:
		if not machine.state.name in ["Thrown", "Dead"]:
			bullet_hit()

func bullet_hit():
	if is_dead:
		return

	health -= 1
	Hotel.check_in(self)
	Cam.screenshake(0.25)

	health = clamp(health, 0, max_health)

	if health <= 0:
		machine.transit("Dead")
	else:
		Util.play_then_return(anim, "hit")


######################################################
# DEATH

signal dying
var is_dead = false

func die():
	if is_dead:
		return

	is_dead = true
	Hotel.check_in(self)
	dying.emit(self)

	# tween shrink
	var duration = 0.5
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.3, 0.3), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.3, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(clean_up_and_free)

func clean_up_and_free():
	queue_free()
