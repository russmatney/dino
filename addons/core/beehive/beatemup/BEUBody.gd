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
	return U._config_warning(self, {expected_nodes=[
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

@export var display_name: String

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

@onready var machine = $BEUMachine
@onready var anim = $AnimatedSprite2D
@onready var state_label = $StateLabel

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

signal changed_weapon(weapon)
var weapon_set: WeaponSet = WeaponSet.new("beu")

## ready ###########################################################

func _ready():
	Hotel.register(self)
	if not Engine.is_editor_hint():
		U.set_optional_nodes(self, {cam_pof="CamPOF"})

		machine.transitioned.connect(_on_transit)

		punch_box = $PunchBox
		punch_box.body_entered.connect(on_punchbox_body_entered)
		punch_box.body_exited.connect(on_punchbox_body_exited)
		punch_box.area_entered.connect(on_punchbox_area_entered)
		punch_box.area_exited.connect(on_punchbox_area_exited)

		grab_box = $GrabBox
		grab_box.body_entered.connect(on_grabbox_body_entered)
		grab_box.body_exited.connect(on_grabbox_body_exited)

		notice_box = $NoticeBox
		notice_box.body_entered.connect(on_noticebox_body_entered)
		notice_box.body_exited.connect(on_noticebox_body_exited)

		weapon_set.changed_weapon.connect(func(w):
			changed_weapon.emit(w))

## physics_process ###########################################################

func remove_invalid(xs):
	return xs.filter(func(x): return is_instance_valid(x))

func _physics_process(_delta):
	punch_box_bodies = remove_invalid(punch_box_bodies)
	grab_box_bodies = remove_invalid(grab_box_bodies)
	notice_box_bodies = remove_invalid(notice_box_bodies)


## on_transit ###########################################################

func _on_transit(label):
	state_label.set_text("[center]%s" % label)


## hotel ###########################################################

func hotel_data():
	var d = {health=health, name=name, lives_lost=lives_lost, kos=kos, is_dead=is_dead}
	if not display_name in ["", null]: # yay types! woo!
		d["display_name"] = display_name
	return d

func check_out(data):
	health = U.get_(data, "health", initial_health)
	lives_lost = U.get_(data, "lives_lost", lives_lost)
	kos = U.get_(data, "kos", kos)
	is_dead = U.get_(data, "is_dead", is_dead)
	display_name = U.get_(data, "display_name", display_name)


## facing ###########################################################

func update_facing():
	U.update_h_flip(facing_vector, punch_box)
	U.update_h_flip(facing_vector, grab_box)
	U.update_h_flip(facing_vector, notice_box)
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

func on_punchbox_area_entered(area):
	if not area in punch_box_bodies:
		punch_box_bodies.append(area)

func on_punchbox_area_exited(area):
	punch_box_bodies.erase(area)


## grabbing ###########################################################

func grab():
	var body = U.nearest_node(self, grab_box_bodies)
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
		return is_instance_valid(att) and not att.is_dead and att.machine.state.name in [
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

func take_hit(opts):
	take_damage(opts)

	var body = opts.get("body")
	var hit_type = opts.get("hit_type")

	if health <= 0:
		die({killed_by=body})
		if hit_type != "hit_by_throw":
			body.kos += 1
		Hotel.check_in(body)

func take_damage(opts):
	var hit_type = opts.get("hit_type")
	var body = opts.get("body")

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

## recover health ###########################################################

# if no arg passed, recovers _all_ health
func recover_health(h=null):
	if h == null:
		health = initial_health
	else:
		health += h

	health = clamp(health, 0, initial_health)

	Hotel.check_in(self)

## death ###########################################################

signal died()
signal dying(body)

func die(opts={}):
	dying.emit(self)
	is_dead = true
	lives_lost += 1
	Hotel.check_in(self)
	machine.transit("Dying", {
		direction=-1*facing_vector,
		killed_by=opts.get("killed_by"),
		})


#################################################################################
## weapons #######################################################

func add_weapon(ent_id):
	var w = weapon_set.add_weapon(ent_id)
	if w:
		# no new child returned if weapon_ent already exists on a weapon
		add_child(w)

func remove_weapon_by_id(ent_id):
	var w = weapon_set.remove_weapon_by_id(ent_id)
	if w:
		remove_child(w)
		w.queue_free()

func has_weapon():
	return weapon_set.has_weapon()

func has_weapon_id(ent_id):
	return weapon_set.has_weapon_id(ent_id)

func active_weapon():
	return weapon_set.active_weapon()

func aim_weapon(aim_vector):
	return weapon_set.aim_weapon(aim_vector)

func cycle_weapon():
	return weapon_set.cycle_weapon()

func activate_weapon(entity):
	return weapon_set.activate_weapon_with_entity(entity)

# Uses the first weapon if none is passed
func use_weapon(weapon=null):
	return weapon_set.use_weapon(weapon)

# i.e. button released, stop firing or whatever continuous action
func stop_using_weapon(weapon=null):
	return weapon_set.stop_using_weapon(weapon)
