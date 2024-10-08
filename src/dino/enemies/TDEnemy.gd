extends CharacterBody2D
class_name TDEnemy

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"TDEnemyMachine", "StateLabel", "AnimatedSprite2D",
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

# nodes

@onready var coll = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var machine = $TDEnemyMachine
@onready var state_label = $StateLabel

var hurt_box
var notice_box
var pit_detector

var heart_particles
var skull_particles

## ready ###########################################################

func _ready():
	Hotel.register(self)

	if not Engine.is_editor_hint():
		U.set_optional_nodes(self, {
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
	health = U.get_(data, "health", initial_health)
	is_dead = U.get_(data, "is_dead", is_dead)
	display_name = U.get_(data, "display_name", display_name)

## collision ###########################################################

# Should be called immediately after move_and_slide in physics_process
# if it returns true, the calling physics_process should return to avoid moving to another state
# func collision_check():
# 	for i in get_slide_collision_count():
# 		var collision = get_slide_collision(i)
# 		var collider = collision.get_collider()
# 		if is_instance_valid(collider) and collider.is_in_group("pits"):
# 			Log.info("pit hit", collider)

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

func die(_opts={}):
	is_dead = true
	Hotel.check_in(self)

## damage ###########################################################

func take_hit(opts):
	take_damage(opts)
	var hit_type = opts.get("type")
	var body = opts.get("body")
	# probably worth supporting direction as well
	var _dir = opts.get("direction")

	Sounds.play(Sounds.S.playerhurt)

	if health <= 0:
		die()
		machine.transit("Dying", {killed_by=body})
	else:
		machine.transit("KnockedBack", {knocked_by=body, hit_type=hit_type})

func take_damage(opts):
	var hit_type = opts.get("type")
	var damage = opts.get("damage")

	if damage == null:
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
	if not body is TDPlayer:
		return
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in hurt_box_bodies:
			hurt_box_bodies.append(body)
			self.take_hit({type="bump", body=body})

func on_hurt_box_exited(body):
	hurt_box_bodies.erase(body)

## notice_box ###########################################################

var notice_box_bodies = []

func on_notice_box_entered(body):
	if not body is TDPlayer:
		return
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in notice_box_bodies:
			notice_box_bodies.append(body)

func on_notice_box_exited(body):
	notice_box_bodies.erase(body)

## stamp ##########################################################################

# Supports 'perma-stamp' with ttl=0
# TODO refactor into shared anim/util lib (juice?)
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
		U.add_child_to_level(self, new_anim)

		var ttl = opts.get("ttl", 0.5)
		if ttl > 0:
			var t = create_tween()
			t.tween_property(new_anim, "scale", Vector2(new_scale, new_scale), ttl)
			t.parallel().tween_property(new_anim, "modulate:a", 0.3, ttl)
			t.tween_callback(new_anim.queue_free)


