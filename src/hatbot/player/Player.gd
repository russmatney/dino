@tool
extends SSPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

@onready var light = $PointLight2D
@onready var light_occluder = $LightOccluder2D
@onready var look_point = $LookPoint

@onready var high_wall_check = $HighWallCheck
@onready var low_wall_check = $LowWallCheck
@onready var wall_checks = [high_wall_check, low_wall_check]
@onready var near_ground_check = $NearGroundCheck

@onready var heart_particles = $HeartParticles
@onready var skull_particles = $SkullParticles

@onready var sword = $Sword

var og_position
var MAX_Y = 5000

var death_count = 0
var death_jumbo_open = false
var coins = 0

var powerups = []
var has_sword = false
var has_double_jump = false
var has_climb = false

## ready ##################################################################

var hud = preload("res://src/hatbot/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self,
			# zoom_rect_min=200,
			# zoom_margin_min=120,
			})
		Hood.ensure_hud(hud)

	if not Game.is_managed:
		powerups = HatBot.all_powerups

	super._ready()

	if not Engine.is_editor_hint():
		# TODO could we just Actions.register(self) or Trolley.register(self)?
		# include opting into keybindings and current-ax updates
		action_detector.setup(self, {actions=actions, action_hint=action_hint,
			can_execute_any=func(): return not machine.state.name in ["Rest"]})

	if not has_sword:
		sword.set_visible(false)

	died.connect(_on_player_death)

	heart_particles.set_emitting(false)
	skull_particles.set_emitting(false)

func _on_transit(state):
	# Debug.debug_label("Player State: ", state)
	# Debug.debug_label("Player pos: ", global_position)

	if state in ["Fall", "Run"]:
		stamp()


## actions ##########################################################################

func can_execute_any_actions():
	return move_target == null and not machine.state.name in ["Rest"]

var actions = [
	# Action.mk({label="Ascend",
	# 	fn=func(player): player.machine.transit("Ascend"),
	# 	actor_can_execute=func(p): return not p.is_dead,
	# 	}),
	# Action.mk({label="Descend",
	# 	fn=func(player): player.machine.transit("Descend"),
	# 	actor_can_execute=func(p): return not p.is_dead,
	# 	})
	]


## hotel data ##########################################################################

func hotel_data():
	var d = super.hotel_data()
	d["powerups"] = powerups
	d["death_count"] = death_count
	d["coins"] = coins
	return d

func check_out(data):
	super.check_out(data)
	death_count = data.get("death_count", death_count)
	coins = data.get("coins", coins)
	var stored_powerups = data.get("powerups", powerups)
	if len(stored_powerups) > 0:
		powerups = stored_powerups

	for p in powerups:
		update_with_powerup(p)


## input ##########################################################################

func _unhandled_input(event):
	if Trolley.is_action(event):
		stamp({scale=2.0, ttl=1.0, include_action_hint=true})
		action_detector.execute_current_action()
		action_detector.current_action()
		Cam.hitstop("player_hitstop", 0.5, 0.2)

	if Trolley.is_attack(event):
		if has_sword:
			sword.swing()
			stamp({scale=2.0, ttl=1.0})

	if Trolley.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_prev_action()
	elif Trolley.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_next_action()


## physics process ##########################################################################

func _physics_process(delta):
	super._physics_process(delta)

	if move_vector:
		# TODO perhaps we care about the deadzone here (for joysticks)
		if move_vector.y > 0:
			aim_sword(Vector2.DOWN)
		elif move_vector.y < 0:
			aim_sword(Vector2.UP)
		else:
			aim_sword(facing_vector)


## movement ##########################################################################

# TODO re-incorporate guided movement, maybe as a new state
var move_target
var move_target_threshold = 10

func get_move_vector():
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

# TODO perhaps a state for this
func move_to_target(target_position):
	move_target = target_position

func clear_move_target():
	move_target = null


## facing ##########################################################################

# TODO dry up against Util version
func update_los_facing(p_facing, node):
	if p_facing == Vector2.RIGHT and node.scale.y < 0:
		node.scale.y = 1
		node.position.x = -node.position.x
	elif p_facing == Vector2.LEFT and node.scale.y > 0:
		node.scale.y = -1
		node.position.x = -node.position.x

func update_facing():
	super.update_facing() # updates `facing_vector`
	Util.update_h_flip(facing_vector, sword)
	Util.update_h_flip(facing_vector, light_occluder)
	Util.update_h_flip(facing_vector, look_point)
	update_los_facing(facing_vector, high_wall_check)
	update_los_facing(facing_vector, low_wall_check)


## health #######################################################

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
			Hotel.check_in(p, {health=p.initial_health})})})


## coins #######################################################

func add_coin():
	coins += 1
	Hotel.check_in(self)


## powerups #######################################################

func update_with_powerup(powerup: HatBot.Powerup):
	match (powerup):
		HatBot.Powerup.Sword: add_sword()
		HatBot.Powerup.DoubleJump: add_double_jump()
		HatBot.Powerup.Climb: add_climb()

func add_powerup(powerup: HatBot.Powerup):
	powerups.append(powerup)
	update_with_powerup(powerup)
	Hotel.check_in(self)


## sword #######################################################

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


## double jump #######################################################

func add_double_jump():
	has_double_jump = true


## climb #######################################################

func add_climb():
	has_climb = true


## stamp frame ##########################################################################

func stamp(opts={}):
	if not Engine.is_editor_hint() and move_target == null:
		var new_scale = opts.get("scale", 0.3)
		var new_anim = AnimatedSprite2D.new()
		new_anim.sprite_frames = anim.sprite_frames
		new_anim.animation = anim.animation
		new_anim.frame = anim.frame

		if opts.get("include_action_hint", false):
			var ax_hint = action_hint.duplicate()
			new_anim.add_child(ax_hint)

		new_anim.global_position = global_position + anim.position
		Navi.add_child_to_current(new_anim)

		var ttl = opts.get("ttl", 0.5)
		if ttl > 0:
			var t = create_tween()
			t.tween_property(new_anim, "scale", Vector2(new_scale, new_scale), ttl)
			t.parallel().tween_property(new_anim, "modulate:a", 0.3, ttl)
			t.tween_callback(new_anim.queue_free)
