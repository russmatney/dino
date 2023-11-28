@tool
extends SSBody
class_name SSPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var look_pof
var light
var light_occluder

var sword
var gun
var bow
var flashlight
var boomerang

var coins = 0
var powerups = []

var aim_vector = Vector2.ZERO

@export var has_bow: bool
@export var has_gun: bool
@export var has_sword: bool
@export var has_flashlight: bool
@export var has_boomerang: bool

## config warning ###########################################################

func _get_configuration_warnings():
	var warns = super._get_configuration_warnings()
	var more = U._config_warning(self, {expected_nodes=[
		"ActionDetector", "ActionHint", "LookPOF",
		]})
	warns.append_array(more)
	return warns

## enter tree ###########################################################

func _enter_tree():
	add_to_group("player", true)

## actions ###########################################################

var actions = [
	Action.mk({label="Ascend",
		fn=func(player): player.machine.transit("Ascend"),
		actor_can_execute=func(p): return not p.is_dead and p.has_ascend,
		}),
	Action.mk({label="Descend",
		fn=func(player): player.machine.transit("Descend"),
		actor_can_execute=func(p): return not p.is_dead and p.has_descend,
		})
	]

## ready ###########################################################

func _ready():
	U.set_optional_nodes(self, {
		look_pof="LookPOF", light_occluder="LightOccluder2D", light="PointLight2D"
		})

	if not Engine.is_editor_hint():
		# TODO maybe skip or never call these in beehive bodies (leave for game overwrites)
		# could otherwise be optional (opt-in or opt-out)
		Cam.request_camera({player=self, zoom_rect_min=600, zoom_margin_min=120})

		action_detector.setup(self, {actions=actions, action_hint=action_hint,
			can_execute_any=func(): return machine and machine.state and not machine.state.name in ["Rest"]})

		if has_sword:
			add_sword()
		if has_flashlight:
			add_flashlight()
		if has_bow:
			add_bow()
		if has_gun:
			add_gun()
		if has_boomerang:
			add_boomerang()

	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true)
	set_collision_mask_value(5, true)
	set_collision_mask_value(6, true)

	super._ready()

## hotel data ##########################################################################

func hotel_data():
	var d = super.hotel_data()
	d["powerups"] = powerups
	d["coins"] = coins
	d["pickups"] = pickups
	return d

func check_out(data):
	super.check_out(data)
	coins = data.get("coins", coins)
	pickups = data.get("pickups", pickups)
	var stored_powerups = data.get("powerups", powerups)
	if len(stored_powerups) > 0:
		powerups = stored_powerups

	for p in powerups:
		update_with_powerup(p)

## input ###########################################################

func _unhandled_input(event):
	# prevent input
	if block_control or is_dead or machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		Log.pr("blocking ss player control")
		return

	# jetpack
	if has_jetpack and Trolley.is_jetpack(event):
		machine.transit("Jetpack")

	# dash
	if has_dash and Trolley.is_dash(event) and not machine.state.name in ["Dash"]:
		machine.transit("Dash")

	# generic weapon
	if has_weapon() and Trolley.is_attack(event):
		use_weapon()
		# should strafe?
	elif has_weapon() and Trolley.is_attack_released(event):
		stop_using_weapon()
		# should stop strafe?

	if Trolley.is_event(event, "cycle_weapon"):
		cycle_weapon()
		Log.prn("cycled weapons", weapons)
		if weapons.size() > 0:
			Hood.notif(str("Changed weapon: ", weapons[0].display_name))
		notif(active_weapon().display_name)

	# generic action
	if Trolley.is_action(event):
		stamp({scale=2.0, ttl=1.0, include_action_hint=true})
		action_detector.execute_current_action()
		action_detector.current_action()
		Cam.hitstop("player_hitstop", 0.5, 0.2)

	# action cycling
	if Trolley.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_prev_action()
	elif Trolley.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_next_action()

## physics_process ###########################################################

func _physics_process(_delta):
	# checks forced_movement_target, then uses Trolley.move_vector
	move_vector = get_move_vector()

	if not Engine.is_editor_hint():
		if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
			# restore strafing - check if using a weapon that supports strafing?
			# if not firing: # supports strafing (moving while firing without turning)
			if move_vector.x > 0:
				facing_vector = Vector2.RIGHT
			elif move_vector.x < 0:
				facing_vector = Vector2.LEFT
			update_facing()

		if move_vector.abs().length() > 0 and has_weapon():
			# maybe this just works?
			aim_vector = move_vector
			aim_weapon(aim_vector)

## facing ###########################################################

func update_facing():
	super.update_facing()
	U.update_h_flip(facing_vector, look_pof)
	U.update_h_flip(facing_vector, light_occluder)

## forced target ##########################################################################

var block_control = false
var forced_movement_target
var forced_movement_target_threshold = 10

func get_move_vector():
	if forced_movement_target != null:
		var towards_target = forced_movement_target - position
		var dist = towards_target.length()
		if dist >= forced_movement_target_threshold:
			return towards_target.normalized()
		else:
			return Vector2.ZERO
		# note, no movement can occur until forced_movement_target is unset
	else:
		return Trolley.move_vector()

func force_move_to_target(target_position):
	block_control = true
	forced_movement_target = target_position

func clear_forced_movement_target():
	block_control = false
	forced_movement_target = null

## pickups #####################################################################

var pickups = []

signal pickups_changed(pickups)

func collect_pickup(pickup_type):
	notif(pickup_type.capitalize() + " PICKED UP", {"dupe": true})
	pickups.append(pickup_type)
	pickups_changed.emit(pickups)

	Hotel.check_in(self, {pickups=pickups})

## powerups #######################################################

func update_with_powerup(powerup: SSData.Powerup):
	match (powerup):
		SSData.Powerup.Sword: add_sword()
		SSData.Powerup.Flashlight: add_flashlight()
		SSData.Powerup.Gun: add_gun()
		SSData.Powerup.Ascend: add_ascend()
		SSData.Powerup.Descend: add_descend()
		SSData.Powerup.DoubleJump: add_double_jump()
		SSData.Powerup.Climb: add_climb()
		SSData.Powerup.Jetpack: add_jetpack()

func add_powerup(powerup: SSData.Powerup):
	powerups.append(powerup)
	update_with_powerup(powerup)
	Hotel.check_in(self)


## coins #######################################################

func add_coin():
	coins += 1
	Hotel.check_in(self)

## gun/fire/bullets ###########################################################

var gun_scene = preload("res://addons/beehive/sidescroller/weapons/Gun.tscn")

func add_gun():
	if not gun:
		gun = gun_scene.instantiate()
		add_child(gun)

	add_weapon(gun)
	has_gun = true

## bow ###########################################################

var bow_scene = preload("res://addons/beehive/sidescroller/weapons/Bow.tscn")

func add_bow():
	if not bow:
		bow = bow_scene.instantiate()
		add_child(bow)

	add_weapon(bow)
	has_bow = true

## sword #######################################################

var sword_scene = preload("res://addons/beehive/sidescroller/weapons/Sword.tscn")

func add_sword():
	if not sword:
		sword = sword_scene.instantiate()
		add_child(sword)

	add_weapon(sword)
	has_sword = true

## flashlight #######################################################

var flashlight_scene = preload("res://addons/beehive/sidescroller/weapons/Flashlight.tscn")

func add_flashlight():
	if not flashlight:
		flashlight = flashlight_scene.instantiate()
		add_child(flashlight)

	add_weapon(flashlight)
	has_flashlight = true

## boomerang ###########################################################

var boomerang_scene = preload("res://addons/beehive/sidescroller/weapons/Boomerang.tscn")

func add_boomerang():
	if not boomerang:
		boomerang = boomerang_scene.instantiate()
		add_child(boomerang)

	Log.pr("adding boomerang to player", self)

	add_weapon(boomerang)
	has_boomerang = true
