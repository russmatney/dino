extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var action_hint = $ActionHint
@onready var action_detector = $ActionDetector
@onready var light = $PointLight2D

@onready var high_wall_check = $HighWallCheck
@onready var low_wall_check = $LowWallCheck
@onready var wall_checks = [high_wall_check, low_wall_check]
@onready var near_ground_check = $NearGroundCheck

@onready var heart_particles = $HeartParticles
@onready var skull_particles = $SkullParticles

var og_position
var MAX_Y = 5000

###########################################################################
# ready

var hud = preload("res://src/hatbot/hud/HUD.tscn")

func _enter_tree():
	Hotel.book(self.scene_file_path)

func _ready():
	og_position = position
	Cam.ensure_camera({zoom_level=5.0, player=self})
	Hood.ensure_hud(hud)
	machine.start()
	machine.transitioned.connect(_on_transit)

	if not Game.is_managed:
		powerups = HatBot.all_powerups

	Hotel.register(self)

	action_detector.setup(self, {can_execute_any=can_execute_any_actions, action_hint=action_hint})

	if not has_sword:
		sword.set_visible(false)

	player_death.connect(_on_player_death)

	heart_particles.set_emitting(false)
	skull_particles.set_emitting(false)

func _on_transit(state):
	# Debug.debug_label("Player State: ", state)
	# Debug.debug_label("Player pos: ", global_position)

	if state in ["Fall", "Run"]:
		stamp()

###########################################################################
# hotel data

func check_out(data):
	health = data.get("health", health)
	death_count = data.get("death_count", death_count)
	coins = data.get("coins", coins)
	var stored_powerups = data.get("powerups", powerups)
	if len(stored_powerups) > 0:
		powerups = stored_powerups

	for p in powerups:
		update_with_powerup(p)

func hotel_data():
	return {health=health, powerups=powerups, death_count=death_count, coins=coins}

###########################################################################
# actions

func can_execute_any_actions():
	return move_target == null and not machine.state.name in ["Rest"]

###########################################################################
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		stamp({scale=2.0, ttl=1.0, include_action_hint=true})
		var _executed = action_detector.execute_current_action()
		# TODO fire stamp via actions api? use whatever the current action_hint is?
		Cam.hitstop("player_hitstop", 0.5, 0.2)
	elif Trolley.is_attack(event):
		if has_sword:
			sword.swing()
			stamp({scale=2.0, ttl=1.0})

###########################################################################
# movement

const SPEED = 150.0
const CLIMB_SPEED = -100.0

# const JUMP_ACCEL = -50.0
# const JUMP_VELOCITY_INITIAL = -100.0
# const JUMP_VELOCITY_MAX = -300.0

const JUMP_VELOCITY = -300.0
const KNOCKBACK_VELOCITY = -300.0
const KNOCKBACK_VELOCITY_HORIZONTAL = 30.0
const DYING_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_dir = Vector2.ZERO
var move_target
var move_target_threshold = 10

func get_move_dir():
	if move_target != null:
		var towards_target = move_target - position
		var dist = towards_target.length()
		if dist >= move_target_threshold:
			return towards_target.normalized()
		else:
			return Vector2.ZERO
		# note, no movement can occur until move_target is unset
	else:
		return Trolley.move_vector()

func _physics_process(_delta):
	# assign move_dir
	move_dir = get_move_dir()

	if move_dir:
		# update facing
		if move_dir.x > 0:
			face_right()
		if move_dir.x < 0:
			face_left()

		if move_dir.y > 0:
			aim_sword(Vector2.DOWN)
		elif move_dir.y < 0:
			aim_sword(Vector2.UP)
		else:
			aim_sword(facing)

	if position.y > MAX_Y:
		Debug.warn("MAX Y HIT - RESETTING PLAYER")
		velocity = Vector2.ZERO
		position = og_position

func move_to_target(target_position):
	move_target = target_position

func clear_move_target():
	move_target = null


###########################################################################
# stamp frame

func stamp(opts={}):
	if not Engine.is_editor_hint() and move_target == null:
		var new_scale = opts.get("scale", 0.3)
		var ttl = opts.get("ttl", 0.5)
		var new_anim = AnimatedSprite2D.new()
		new_anim.sprite_frames = anim.sprite_frames
		new_anim.animation = anim.animation
		new_anim.frame = anim.frame

		if opts.get("include_action_hint", false):
			var ax_hint = action_hint.duplicate()
			new_anim.add_child(ax_hint)

		# definitely more position work to do...?
		new_anim.global_position = global_position + anim.position
		Navi.add_child_to_current(new_anim)

		if ttl > 0:
			var t = create_tween()
			t.tween_property(new_anim, "scale", Vector2(new_scale, new_scale), ttl)
			t.parallel().tween_property(new_anim, "modulate:a", 0.3, ttl)
			t.tween_callback(new_anim.queue_free)


###########################################################################
# facing

# TODO dry up against Util version
func update_los_facing(p_facing, node):
	if p_facing == Vector2.RIGHT and node.scale.y < 0:
		node.scale.y = 1
		node.position.x = -node.position.x
	elif p_facing == Vector2.LEFT and node.scale.y > 0:
		node.scale.y = -1
		node.position.x = -node.position.x

var facing

@onready var light_occluder = $LightOccluder2D
@onready var look_point = $LookPoint

func face_right():
	if facing == Vector2.LEFT:
		stamp()
	facing = Vector2.RIGHT
	anim.flip_h = false
	Util.update_h_flip(facing, sword)
	Util.update_h_flip(facing, light_occluder)
	Util.update_h_flip(facing, look_point)
	update_los_facing(facing, high_wall_check)
	update_los_facing(facing, low_wall_check)

func face_left():
	if facing == Vector2.RIGHT:
		stamp()
	facing = Vector2.LEFT
	anim.flip_h = true
	Util.update_h_flip(facing, sword)
	Util.update_h_flip(facing, light_occluder)
	Util.update_h_flip(facing, look_point)
	update_los_facing(facing, high_wall_check)
	update_los_facing(facing, low_wall_check)

########################################################
# health

signal player_death

var max_health = 6
var health = max_health

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.RIGHT)
	DJZ.play(DJZ.S.playerhurt)

	health -= damage
	health = clamp(health, 0, max_health)
	Hotel.check_in(self)
	machine.transit("KnockedBack", {"direction": direction})

func heal(opts={}):
	DJZ.play(DJZ.S.playerheal)
	anim.play("sit")

	# force one-shot emission
	Debug.pr(heart_particles)
	heart_particles.set_emitting(true)
	heart_particles.restart()

	var h = opts.get("health", 1)
	health += h
	health = clamp(health, 0, max_health)
	Hotel.check_in(self)

var death_count = 0

var death_jumbo_open = false

func _on_player_death():
	if death_jumbo_open:
		return
	death_jumbo_open = true

	stamp({ttl=0}) # perma stamp
	death_count += 1
	Hotel.check_in(self)
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

	Quest.jumbo_notif({header="You died", body="Sorry about it!",
		action="close", action_label_text="Respawn",
		on_close=Game.respawn_player.bind({setup_fn=func(p):
			Hotel.check_in(p, {health=p.max_health})})})

########################################################
# coins

var coins = 0

func add_coin():
	coins += 1
	Hotel.check_in(self)

########################################################
# powerups

var powerups = []
var has_sword = false
var has_double_jump = false
var has_climb = false

func update_with_powerup(powerup: HatBot.Powerup):
	match (powerup):
		HatBot.Powerup.Sword: add_sword()
		HatBot.Powerup.DoubleJump: add_double_jump()
		HatBot.Powerup.Climb: add_climb()

func add_powerup(powerup: HatBot.Powerup):
	powerups.append(powerup)
	update_with_powerup(powerup)
	Hotel.check_in(self)

########################################################
# sword

@onready var sword = $Sword

func add_sword():
	sword.set_visible(true)
	sword.bodies_updated.connect(_on_sword_bodies_updated)
	has_sword = true

func _on_sword_bodies_updated(bodies):
	if len(bodies) > 0:
		# TODO hide when we've seen some amount of sword action
		# i.e. the player has learned it
		# TODO combine with 'forget learned actions' pause button
		action_hint.display("attack", "Sword")
	else:
		action_hint.hide()

func aim_sword(dir):
	if has_sword:
		match (dir):
			Vector2.UP:
				sword.rotation_degrees = -90.0
				sword.position.x = -8
				sword.position.y = -10
				sword.scale.x = 1
			Vector2.DOWN:
				sword.rotation_degrees = 90.0
				sword.position.x = 9
				sword.position.y = 12
				sword.scale.x = 1
			Vector2.LEFT:
				sword.rotation_degrees = 0.0
				sword.position.x = -9
				sword.position.y = -10
				sword.scale.x = -1
			Vector2.RIGHT:
				sword.rotation_degrees = 0.0
				sword.position.x = 9
				sword.position.y = -10
				sword.scale.x = 1

########################################################
# double jump

func add_double_jump():
	has_double_jump = true

########################################################
# climb

func add_climb():
	has_climb = true
