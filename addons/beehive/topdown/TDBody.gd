@tool
extends CharacterBody2D
class_name TDBody

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
@export var jump_speed: float = 10000

# vars

var move_vector: Vector2
var facing_vector: Vector2
var health
var is_dead
var is_player

# nodes

@onready var coll = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var machine = $TDMachine
@onready var state_label = $StateLabel

var notif_label
var hurt_box

var heart_particles
var skull_particles


## enter_tree ###########################################################

func _enter_tree():
	Hotel.book(self)

## ready ###########################################################

func _ready():
	Hotel.register(self)

	if is_in_group("player"):
		is_player = true

	if not Engine.is_editor_hint():
		Util.set_optional_nodes(self, {
			notif_label="NotifLabel",
			hurt_box="HurtBox",
			heart_particles="HeartParticles",
			skull_particles="SkullParticles",
			})

		if hurt_box:
			hurt_box.body_entered.connect(on_hurt_box_entered)
			hurt_box.body_exited.connect(on_hurt_box_exited)

		if heart_particles:
			heart_particles.set_emitting(false)
		if skull_particles:
			skull_particles.set_emitting(false)

		machine.transitioned.connect(_on_transit)
		machine.start()

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
	# all art should face RIGHT by default
	anim.flip_h = facing_vector.x < 0

func face_body(body):
	if not body:
		return
	var pos_diff = body.global_position - global_position
	facing_vector = pos_diff.normalized()
	update_facing()

func update_run_anim():
	if move_vector.y > 0:
		anim.play("run_down")
	elif move_vector.y < 0:
		anim.play("run_up")
	elif move_vector.x > 0:
		anim.play("run_right")
	elif move_vector.x < 0:
		# assumes anim h_flip is done elsewhere
		anim.play("run_right")

func update_idle_anim():
	if facing_vector.y > 0:
		anim.play("idle_down")
	elif facing_vector.y < 0:
		anim.play("idle_up")
	elif facing_vector.x > 0:
		anim.play("idle_right")
	elif facing_vector.x < 0:
		# assumes anim h_flip is done elsewhere
		anim.play("idle_right")

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
	# TODO probably worth supporting direction as well
	var _dir = opts.get("direction")

	# TODO different sound based on actor being hit, hit-type, etc
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

func on_hurt_box_entered(body):
	# TODO ignore other bodies
	# if body is SSBody: # can't write this in same-name class script
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in hurt_box_bodies:
			hurt_box_bodies.append(body)
			body.take_hit({type="bump", body=self})

func on_hurt_box_exited(body):
	hurt_box_bodies.erase(body)

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

