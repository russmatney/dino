## BeatEmUp Body
##
## This class is closely integrated with the BEUMachine and it's states.
## It expects to be subclassed for the player or any specific details
## (e.g. overwriting passive_frames to tweak a specific animation+interaction).
##
## It provides configuration warnings that try to ensure expected nodes and
## animations are present - note that missing some animations will render
## certain states useless, because they depend on the animation_finished signal
## to move to the next state.
##
## All sprites should face RIGHT, otherwise all the facing logic will be backwards.
@tool
extends CharacterBody2D
class_name BEUBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"BEUMachine", "StateLabel",
		"PunchBox", "GrabBox", "NoticeBox",
		"AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": [
			"falling", "landed", "idle", "walk",
			"punch", "punch_2", "punched",
			"kick", "kicked", "jump", "jump_kick",
			"grab", "grabbed", "throw", "thrown",
			"hit_ground", "get_up", "dead"]}})


## vars #############################################################

@export var should_wander: bool = false
@export var should_notice: bool = false
@export var jump_speed: int = 10000
@export var throw_speed: int = 12000
@export var wander_speed: int = 4000
@export var walk_speed: int = 10000
@export var kicked_speed: int = 7000
@export var max_attackers: int = 1
@export var initial_health: int = 20
var dying_knockback_speed: int = 11000

@export var punch_power: int = 3
@export var kick_power: int = 5
@export var throw_power: int = 3
@export var weight: int = 4
@export var defense: int = 1

var machine
var anim
var state_label
var punch_box
var grab_box
var notice_box
var cam_pof

var move_vector: Vector2
var facing_vector: Vector2
var health
var is_dead
var lives_lost: int = 0
var kos: int = 0


## enter_tree ###########################################################

func _enter_tree():
	Hotel.book(self)

## ready ###########################################################

func _ready():
	Hotel.register(self)
	if not Engine.is_editor_hint():
		machine = $BEUMachine
		state_label = $StateLabel
		punch_box = $PunchBox
		grab_box = $GrabBox
		notice_box = $NoticeBox
		anim = $AnimatedSprite2D
		if get_node_or_null("CamPOF"):
			cam_pof = get_node("CamPOF")

		machine.transitioned.connect(_on_transit)
		machine.start()

		punch_box.body_entered.connect(on_punchbox_body_entered)
		punch_box.body_exited.connect(on_punchbox_body_exited)

		grab_box.body_entered.connect(on_grabbox_body_entered)
		grab_box.body_exited.connect(on_grabbox_body_exited)

		notice_box.body_entered.connect(on_noticebox_body_entered)
		notice_box.body_exited.connect(on_noticebox_body_exited)

## on_transit ###########################################################

func _on_transit(label):
	state_label.set_text("[center]%s" % label)


## hotel ###########################################################

func hotel_data():
	return {health=health, name=name, lives_lost=lives_lost, kos=kos, is_dead=is_dead}

func check_out(data):
	health = Util.get_(data, "health", initial_health)
	lives_lost = Util.get_(data, "lives_lost", lives_lost)
	kos = Util.get_(data, "kos", kos)
	is_dead = Util.get_(data, "is_dead", is_dead)


## facing ###########################################################

func update_facing():
	Util.update_h_flip(facing_vector, punch_box)
	Util.update_h_flip(facing_vector, grab_box)
	Util.update_h_flip(facing_vector, notice_box)
	# all art should face RIGHT by default
	anim.flip_h = facing_vector == Vector2.LEFT

func flip_facing():
	facing_vector *= -1
	update_facing()

func face_body(body):
	var pos_diff = body.global_position - global_position
	if pos_diff.x > 0:
		facing_vector = Vector2.RIGHT
	elif pos_diff.x < 0:
		facing_vector = Vector2.LEFT

	update_facing()

## animations ###########################################################

## returns frames that do NOT imply a punch/kick/some kind of hit
## Can be overwritten in sub-classes
func passive_frames(an):
	var frame_count = an.sprite_frames.get_frame_count(an.animation)

	# 1 or 2 frames? probably both are hits
	if frame_count in [1, 2]:
		return []

	# 3 frames, skip the first
	if frame_count == 3:
		return [0]

	# 4 frames, skip the first
	if frame_count == 4:
		return [0]

	# more than 4 frames, skip the first 2 and last
	var frames = [0, 1, frame_count - 1]

	return frames

## punching ###########################################################

var punch_box_bodies = []

func on_punchbox_body_entered(body):
	if not body in punch_box_bodies:
		punch_box_bodies.append(body)

func on_punchbox_body_exited(body):
	punch_box_bodies.erase(body)


## grabbing ###########################################################

func grab():
	var body = Util.nearest_node(self, grab_box_bodies)
	if body != null and not body.is_dead and "machine" in body:
		body.machine.transit("Grabbed", {grabbed_by=body})
		machine.transit("Grab", {grabbed=body})

var grab_box_bodies = []

func on_grabbox_body_entered(body):
	if not body in grab_box_bodies:
		grab_box_bodies.append(body)

	if len(grab_box_bodies) > 0 and machine.state.name in ["Walk"]:
		grab()

func on_grabbox_body_exited(body):
	grab_box_bodies.erase(body)


## attackers ###########################################################

var attackers = []

func ready_for_new_attacker():
	update_attackers()
	return len(attackers) < max_attackers

func update_attackers():
	attackers = attackers.filter(func(att):
		# only keep attackers in one of these states
		return not att.is_dead and att.machine.state.name in [
			"Punch", "Punched", "Approach", "Attack", "Kick", "Kicked",
			])

func add_attacker(body):
	if not body in attackers:
		attackers.append(body)

func remove_attacker(body):
	attackers.erase(body)


## noticebox ###########################################################

var notice_box_bodies = []

func on_noticebox_body_entered(body):
	if not body in notice_box_bodies:
		notice_box_bodies.append(body)

func on_noticebox_body_exited(body):
	notice_box_bodies.erase(body)


## health ###########################################################

func take_damage(hit_type, body):
	var attack_power
	match hit_type:
		"punch":
			attack_power = body.punch_power
		"kick":
			attack_power = body.kick_power
		"throw":
			attack_power = body.throw_power + weight
		"hit_by_throw":
			# damage based on weight of thrown body that hit us
			attack_power = clamp(int(body.weight/2), 4, 2)

	var damage = attack_power - defense

	health -= damage
	Hotel.check_in(self)

	if health <= 0:
		die({killed_by=body})
		body.kos += 1
		Hotel.check_in(body)

signal died()

func die(opts={}):
	is_dead = true
	lives_lost += 1
	Hotel.check_in(self)
	machine.transit("Dying", {
		direction=-1*facing_vector,
		killed_by=opts.get("killed_by"),
		})
