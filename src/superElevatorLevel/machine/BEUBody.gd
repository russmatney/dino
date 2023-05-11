@tool
extends CharacterBody2D
class_name BEUBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"BEUMachine", "StateLabel",
		"PunchBox", "GrabBox", "NoticeBox",
		"AnimatedSprite2D",
		]})


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
	anim.flip_h = facing_vector == Vector2.LEFT

func face_body(body):
	var pos_diff = body.global_position - global_position
	if pos_diff.x > 0:
		facing_vector = Vector2.RIGHT
	elif pos_diff.x < 0:
		facing_vector = Vector2.LEFT

	update_facing()


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
		die()
		body.kos += 1
		Hotel.check_in(body)

func die():
	Debug.warn("This should be overwritten!")
	machine.transit("Die")
