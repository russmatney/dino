extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var action_hint = $ActionHint

var max_health = 3
var health = 3

###########################################################
# ready

func _ready():
	Hotel.register(self)
	# TODO offInd could be self-sufficient as well
	OffscreenIndicator.add(self, {label="Sheep"})

######################################################
# hotel

func hotel_data():
	return {health=health, is_dead=is_dead, name=name}

func check_out(_data):
	# reset sheep to full health for now
	# health = U.get_(data, "health", health)
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
		player.move_vector.length() <= 0.1 \
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
	DJZ.play(DJZ.S.coin)
	# check_in here also adds to HUD
	# not a great pattern, if HUD grabs/inits automatically this is not necessary
	Hotel.check_in(self)
	U._connect(player.died, on_player_died)
	following = player
	machine.transit("Follow")

func grabbed_by_player(player):
	U._connect(player.died, on_player_died)
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

func on_player_died(_player):
	following = null
	grabbed_by = null

######################################################
# bullets

func _on_bullet_collided(
		body:Node, _body_shape_index:int, _bullet:Dictionary,
		_local_shape_index:int, _shared_area:Area2D
	):
	if body == self:
		if not machine.state.name in ["Thrown", "Dead"]:
			bullet_hit()

func bullet_hit():
	if is_dead:
		return

	DJZ.play(DJZ.S.player_hit)

	health -= 1
	Hotel.check_in(self)
	Cam.screenshake(0.25)

	health = clamp(health, 0, max_health)

	if health <= 0:
		machine.transit("Dead")
	else:
		U.play_then_return(anim, "hit")


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
