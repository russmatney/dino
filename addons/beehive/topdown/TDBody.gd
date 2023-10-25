@tool
extends CharacterBody2D
class_name TDBody

var is_td_body = true

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"TDMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": [
			"idle_down", "idle_up", "idle_right",
			"run_down", "run_up", "run_right",]}})

## vars ###########################################################

# input vars

@export var display_name: String
@export var initial_health: int = 6

@export var run_speed: float = 10000
@export var wander_speed: float = 6000
@export var jump_speed: float = 10000

@export var should_wander: bool = false
@export var should_notice: bool = false

# vars

var move_vector: Vector2
var facing_vector: Vector2
var health
var is_dead
var is_player

var weapons = []

# nodes

@onready var coll = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var machine = $TDMachine
@onready var state_label = $StateLabel

var notif_label
var hurt_box
var notice_box
var pit_detector

var heart_particles
var skull_particles

## ready ###########################################################

func _ready():
	Hotel.register(self)

	if is_in_group("player"):
		is_player = true

	if not Engine.is_editor_hint():
		Util.set_optional_nodes(self, {
			notif_label="NotifLabel",
			hurt_box="HurtBox",
			notice_box="NoticeBox",
			heart_particles="HeartParticles",
			skull_particles="SkullParticles",
			pit_detector="PitDetector",
			})

		if hurt_box:
			hurt_box.body_entered.connect(on_hurt_box_entered)
			hurt_box.body_exited.connect(on_hurt_box_exited)

		if notice_box:
			notice_box.body_entered.connect(on_notice_box_entered)
			notice_box.body_exited.connect(on_notice_box_exited)

		if heart_particles:
			heart_particles.set_emitting(false)
		if skull_particles:
			skull_particles.set_emitting(false)

		machine.transitioned.connect(_on_transit)
		machine.start()

## physics_process ###########################################################

func _physics_process(_delta):
	if notice_box:
		notice_box_bodies = notice_box_bodies.filter(func(b):
			return is_instance_valid(b) and not b.is_dead)


## on_transit ###########################################################

func _on_transit(label):
	state_label.text = "[center]%s" % label


## hotel ###########################################################

func hotel_data():
	var d = {health=health, name=name, is_dead=is_dead}
	if not display_name in ["", null]: # yay types! woo!
		d["display_name"] = display_name
	return d

func check_out(data):
	health = Util.get_(data, "health", initial_health)
	is_dead = Util.get_(data, "is_dead", is_dead)
	display_name = Util.get_(data, "display_name", display_name)

## collision ###########################################################

# Should be called immediately after move_and_slide in physics_process
# if it returns true, the calling physics_process should return to avoid moving to another state
# func collision_check():
# 	Debug.pr("checking collision")
# 	for i in get_slide_collision_count():
# 		Debug.pr("checking collision", i)
# 		var collision = get_slide_collision(i)
# 		var collider = collision.get_collider()
# 		if collider.is_in_group("pits"):
# 			Debug.pr("pit hit", collider)

## facing ###########################################################

func update_facing():
	if move_vector != Vector2.ZERO:
		facing_vector = move_vector
	# all art should face RIGHT by default
	anim.flip_h = facing_vector.x < 0

func face_body(body):
	if not body:
		return
	var pos_diff = body.global_position - global_position
	facing_vector = pos_diff.normalized()
	update_facing()

func update_directional_anim(vec, anim_prefix):
	# favors x-dir over y-dir
	if vec.x > 0:
		anim.play(str(anim_prefix, "_right"))
	elif vec.x < 0:
		# assumes anim h_flip is done elsewhere
		anim.play(str(anim_prefix, "_right"))
	elif vec.y > 0:
		anim.play(str(anim_prefix, "_down"))
	elif vec.y < 0:
		anim.play(str(anim_prefix, "_up"))

func update_run_anim():
	update_directional_anim(move_vector, "run")

func update_idle_anim():
	update_directional_anim(facing_vector, "idle")

func update_jump_anim():
	update_directional_anim(move_vector, "jump")

## death ###########################################################

signal died()

func die(opts={}):
	is_dead = true
	Hotel.check_in(self)

## damage ###########################################################

func take_hit(opts):
	take_damage(opts)
	var hit_type = opts.get("type")
	var body = opts.get("body")
	# probably worth supporting direction as well
	var _dir = opts.get("direction")

	DJZ.play(DJZ.S.playerhurt)

	if health <= 0:
		die()
		machine.transit("Dying", {killed_by=body})
	else:
		machine.transit("KnockedBack", {knocked_by=body, hit_type=hit_type})

func take_damage(opts):
	var hit_type = opts.get("type")
	var body = opts.get("body")
	var damage = opts.get("damage")

	if damage == null:
		var attack_damage
		match hit_type:
			_:
				damage = 1
	health -= damage
	health = clamp(health, 0, initial_health)
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

## hurt_box ###########################################################

var hurt_box_bodies = []
# var is_invincible = false

func on_hurt_box_entered(body):
	# if is_invincible:
	# 	return
	if not "is_td_body" in body:
		Debug.pr("hurt box entered by non td_body", body)
		return
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in hurt_box_bodies:
			hurt_box_bodies.append(body)
			self.take_hit({type="bump", body=body})

			# is_invincible = true
			# await get_tree().create_timer(1.0).timeout
			# is_invincible = false
			# hurt_box_bodies = []

func on_hurt_box_exited(body):
	hurt_box_bodies.erase(body)

## notice_box ###########################################################

var notice_box_bodies = []

func on_notice_box_entered(body):
	if not "is_td_body" in body:
		Debug.pr("notice box entered by non td_body", body)
		return
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in notice_box_bodies:
			notice_box_bodies.append(body)

func on_notice_box_exited(body):
	notice_box_bodies.erase(body)

#################################################################################
## Effects #####################################################################

## notif #####################################################################

var notif_tween

func notif(text, opts = {}):
	if not notif_label:
		return
	var ttl = opts.get("ttl", 1.5)
	var dupe = opts.get("dupe", false)
	var label
	if dupe:
		label = notif_label.duplicate()
	else:
		label = notif_label

	label.text = "[center]" + text
	label.set_visible(true)
	if notif_tween:
		notif_tween.kill()
	notif_tween = create_tween()
	if dupe:
		label.set_global_position(notif_label.get_global_position())
		Navi.add_child_to_current(label)
		notif_tween.tween_callback(label.queue_free).set_delay(ttl)
	else:
		notif_tween.tween_callback(label.set_visible.bind(false)).set_delay(ttl)

## level up #####################################################################

func level_up():
	shine(2.0)
	notif("LEVEL UP", {"dupe": true})
	Hood.notif("Level Up")

## shine #####################################################################

func shine(_time = 1.0):
	pass
	# var tween = create_tween()
	# anim.material.set("shader_parameter/speed", 1.0)
	# tween.tween_callback(anim.material.set.bind("shader_parameter/speed", 0.0)).set_delay(time)

## stamp ##########################################################################

# Supports 'perma-stamp' with ttl=0
func stamp(opts={}):
	if not Engine.is_editor_hint():
		var new_scale = opts.get("scale", 0.3)
		var new_anim = AnimatedSprite2D.new()
		new_anim.sprite_frames = anim.sprite_frames
		new_anim.animation = anim.animation
		new_anim.frame = anim.frame

		if opts.get("include_action_hint", false) and self.get("action_hint"):
			var ax_hint = self["action_hint"].duplicate()
			new_anim.add_child(ax_hint)

		new_anim.global_position = global_position + anim.position
		Navi.add_child_to_current(new_anim)

		var ttl = opts.get("ttl", 0.5)
		if ttl > 0:
			var t = create_tween()
			t.tween_property(new_anim, "scale", Vector2(new_scale, new_scale), ttl)
			t.parallel().tween_property(new_anim, "modulate:a", 0.3, ttl)
			t.tween_callback(new_anim.queue_free)


## weapons #######################################################

func add_weapon(weapon):
	if not weapon in weapons:
		weapons.map(deactivate_weapon)
		weapons.push_front(weapon)
		activate_weapon()

func has_weapon():
	return active_weapon() != null

func active_weapon():
	if len(weapons) > 0:
		return weapons.front()

func aim_weapon(aim_vector):
	var w = active_weapon()
	if w:
		w.aim(aim_vector)

# Drops the first weapon if none is passed
func drop_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	# drop+create new pickup/powerup? remove child?
	if weapon in weapons:
		weapons.erase(weapon)

func cycle_weapon():
	if len(weapons) > 1:
		weapons.map(deactivate_weapon)
		var f = weapons.pop_front()
		weapons.push_back(f)
		activate_weapon()

# maybe different from 'use' for multi-state things like the flashlight?
func activate_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	weapon.visible = true
	weapon.activate()

# turn off the flashlight, sheath the sword, holser the gun?
func deactivate_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	weapon.visible = false
	weapon.deactivate()

# Uses the first weapon if none is passed
func use_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	weapon.use()

# i.e. button released, stop firing or whatever continuous action
func stop_using_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	weapon.stop_using()
