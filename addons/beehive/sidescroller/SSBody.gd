@tool
extends CharacterBody2D
class_name SSBody

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"SSMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": [
			"idle", "run", "jump", "air", "fall",
			"knocked_back", "dying", "dead",]}})

## vars ###########################################################

# input vars

@export var display_name: String
@export var initial_health: int = 6
@export var bump_damage: int = 2
@export var defense: int = 1
@export var should_wander: bool
@export var should_patrol: bool

@export var run_speed: float = 10000
@export var air_speed: float = 9000 # horizontal movement in the air
@export var climb_speed: float = -100.0
@export var knockback_speed_y: float = 100
@export var knockback_speed_x: float = 30
@export var wander_speed: float = 4000

@export var jump_max_height: float = 100.0
@export var jump_min_height: float = 40.0
@export var jump_time: float = 0.3
@export var fall_time: float = 0.3

@onready var jump_velocity: float = ((2.0 * jump_max_height) / jump_time)
@onready var jump_gravity: float = ((2.0 * jump_max_height) / (jump_time * jump_time)) # ~1000
@onready var fall_gravity: float = ((2.0 * jump_max_height) / (fall_time * fall_time)) # ~2000
var gravity = 1000 # for use in non-jump states

# powerups
@export var has_double_jump = false
@export var has_climb = false
@export var has_jetpack = false
@export var has_ascend = false
@export var has_descend = false
@export var has_dash = false

# vars

var move_vector: Vector2
var facing_vector: Vector2
var health
var is_dead
var is_player
var death_count = 0

# nodes

@onready var coll = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var machine = $SSMachine
@onready var state_label = $StateLabel

var jet_anim
var cam_pof
var hurt_box
var nav_agent
var notif_label
var warp_cast

var high_wall_check
var low_wall_check
var wall_checks = []
var near_ground_check

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
		should_wander = false
		should_patrol = false
	elif is_in_group("enemies"):
		is_player = false
		should_wander = true
		should_patrol = true
	else:
		is_player = false
		should_wander = true
		should_patrol = false

	if not Engine.is_editor_hint():
		Util.set_optional_nodes(self, {
			jet_anim="Jet",
			notif_label="NotifLabel",
			cam_pof="CamPOF",
			nav_agent="NavigationAgent2D",
			hurt_box="HurtBox",
			high_wall_check="HighWallCheck",
			low_wall_check="LowWallCheck",
			near_ground_check="NearGroundCheck",
			heart_particles="HeartParticles",
			skull_particles="SkullParticles",
			warp_cast="WarpCast",
			})

		if hurt_box:
			hurt_box.body_entered.connect(on_hurt_box_entered)
			hurt_box.body_exited.connect(on_hurt_box_exited)
		if high_wall_check or low_wall_check:
			wall_checks = [high_wall_check, low_wall_check]
		if heart_particles:
			heart_particles.set_emitting(false)
		if skull_particles:
			skull_particles.set_emitting(false)

		machine.transitioned.connect(_on_transit)
		machine.start()


func get_rect():
	if coll != null:
		var rect = coll.shape.get_rect()
		rect.position += coll.position + global_position
		return rect

## on_transit ###########################################################

func _on_transit(label):
	state_label.text = "[center]%s" % label


## hotel ###########################################################

func hotel_data():
	var d = {health=health, name=name, is_dead=is_dead, death_count=death_count}
	if not display_name in ["", null]: # yay types! woo!
		d["display_name"] = display_name
	return d

func check_out(data):
	health = Util.get_(data, "health", initial_health)
	is_dead = Util.get_(data, "is_dead", is_dead)
	display_name = Util.get_(data, "display_name", display_name)
	death_count = Util.get_(data, "death_count", death_count)

## facing ###########################################################

# TODO dry up against Util version
func update_los_facing(p_facing, node):
	if not node:
		return
	if p_facing == Vector2.RIGHT and node.scale.y < 0:
		node.scale.y = 1
		node.position.x = -node.position.x
	elif p_facing == Vector2.LEFT and node.scale.y > 0:
		node.scale.y = -1
		node.position.x = -node.position.x

func update_facing():
	# all art should face RIGHT by default
	anim.flip_h = facing_vector == Vector2.LEFT
	update_los_facing(facing_vector, high_wall_check)
	update_los_facing(facing_vector, low_wall_check)

func flip_facing():
	# assumes facing vector is always vec.left or vec.right
	facing_vector *= -1
	update_facing()

func face_body(body):
	var pos_diff = body.global_position - global_position
	if pos_diff.x > 0:
		facing_vector = Vector2.RIGHT
	elif pos_diff.x < 0:
		facing_vector = Vector2.LEFT

	update_facing()

## death ###########################################################

signal died()

func die(opts={}):
	is_dead = true
	death_count += 1
	Hotel.check_in(self)

## damage ###########################################################

func take_hit(opts):
	take_damage(opts)
	var hit_type = opts.get("type")
	var body = opts.get("body")

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
			"bump":
				damage = body.bump_damage
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
	var tween = create_tween()
	if dupe:
		label.set_global_position(notif_label.get_global_position())
		Navi.add_child_to_current(label)
		tween.tween_callback(label.queue_free).set_delay(ttl)
	else:
		tween.tween_callback(label.set_visible.bind(false)).set_delay(ttl)

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

#################################################################################
## Powerups #####################################################################

## double jump #######################################################

func add_double_jump():
	has_double_jump = true


## climb #######################################################

func add_climb():
	has_climb = true

func should_start_climb():
	if near_ground_check == null:
		return false
	if len(wall_checks) == 0:
		return false
	if has_climb and is_on_wall_only()\
		and not near_ground_check.is_colliding():
		var coll = get_slide_collision(0)
		var x_diff = coll.get_position().x - global_position.x

		if move_vector.x > 0 and x_diff > 0:
			return true
		if move_vector.x < 0 and x_diff < 0:
			return true
	return false

## dash #######################################################

func add_dash():
	# TODO add dash anim, pull into beehive/sidescroller
	has_dash = true

## jetpack #######################################################

func add_jetpack():
	# TODO add jetpack anim, pull into beehive/sidescroller
	has_jetpack = true

## ascend/descend #######################################################

func add_ascend():
	if not warp_cast:
		Debug.warn("refusing to add ascend powerup")
		return
	# TODO add WarpCast dynamically
	has_ascend = true

func add_descend():
	# TODO add WarpCast dynamically
	if not warp_cast:
		Debug.warn("refusing to add descend powerup")
		return
	has_descend = true
