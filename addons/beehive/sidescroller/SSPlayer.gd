@tool
extends SSBody
class_name SSPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var look_pof
var light
var light_occluder
# TODO pull bullet into beehive/sidescroller
var bullet_position
# TODO pull Sword into beehive/sidescroller
var sword

var coins = 0
var powerups = []


@export var has_gun: bool
@export var has_sword: bool

## config warning ###########################################################

func _get_configuration_warnings():
	var warns = super._get_configuration_warnings()
	var more = Util._config_warning(self, {expected_nodes=[
		"ActionDetector", "ActionHint",
		"LookPOF", "BulletPosition",
		]})
	warns.append_array(more)
	return warns

## enter tree ###########################################################

func _enter_tree():
	add_to_group("player", true)
	# TODO set usual collision layers/masks
	super._enter_tree()

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
	Util.set_optional_nodes(self, {
		look_pof="LookPOF", bullet_position="BulletPosition",
		sword="Sword", light_occluder="LightOccluder2D", light="PointLight2D"
		})

	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		# support some assigned 'hud'
		Hood.ensure_hud(self.get("hud"))

		# TODO could we just Actions.register(self) or Trolley.register(self)?
		# include opting into keybindings and current-ax updates
		action_detector.setup(self, {actions=actions, action_hint=action_hint,
			can_execute_any=func(): return machine and machine.state and not machine.state.name in ["Rest"]})

		if not has_sword and sword:
			sword.set_visible(false)

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
		return

	# jetpack
	if has_jetpack and Trolley.is_event(event, "jetpack"):
		machine.transit("Jetpack")

	# gun/fire
	if has_gun and Trolley.is_event(event, "fire"):
		fire()
	elif has_gun and Trolley.is_event_released(event, "fire"):
		stop_firing()

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

	# generic attack
	if Trolley.is_attack(event):
		if has_sword and sword:
			sword.swing()
			stamp({scale=2.0, ttl=1.0})

## physics_process ###########################################################

func _physics_process(_delta):
	# checks forced_movement_target, then uses Trolley.move_vector
	move_vector = get_move_vector()

	if not Engine.is_editor_hint():
		if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
			if not firing: # supports strafing (moving while firing without turning)
				if move_vector.x > 0:
					facing_vector = Vector2.RIGHT
				elif move_vector.x < 0:
					facing_vector = Vector2.LEFT
			update_facing()

		if move_vector.abs().length() > 0 and has_sword:
			# TODO perhaps we care about the deadzone here (for joysticks)
			if move_vector.y > 0:
				aim_sword(Vector2.DOWN)
			elif move_vector.y < 0:
				aim_sword(Vector2.UP)
			else:
				aim_sword(facing_vector)

## facing ###########################################################

func update_facing():
	super.update_facing()
	Util.update_h_flip(facing_vector, sword)
	Util.update_h_flip(facing_vector, bullet_position)
	Util.update_h_flip(facing_vector, look_pof)
	Util.update_h_flip(facing_vector, light_occluder)

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

# TODO refactor jetpack pickup into ss powerup
func collect_pickup(pickup_type):
	notif(pickup_type.capitalize() + " PICKED UP", {"dupe": true})
	pickups.append(pickup_type)
	pickups_changed.emit(pickups)

	Hotel.check_in(self, {pickups=pickups})

## powerups #######################################################

func update_with_powerup(powerup: SS.Powerup):
	match (powerup):
		SS.Powerup.Sword: add_sword()
		SS.Powerup.DoubleJump: add_double_jump()
		SS.Powerup.Climb: add_climb()
		SS.Powerup.Gun: add_gun()
		SS.Powerup.Jetpack: add_jetpack()

func add_powerup(powerup: SS.Powerup):
	powerups.append(powerup)
	update_with_powerup(powerup)
	Hotel.check_in(self)


## coins #######################################################

func add_coin():
	coins += 1
	Hotel.check_in(self)

## gun/fire/bullets ###########################################################

func add_gun():
	# TODO add bullet/gun scene if one not found
	if not bullet_position:
		Debug.warn("Refusing to add gun, no bullet_position set")
		return
	has_gun = true

var firing = false

# TODO pull metadata into generic, reusable (customizable) bullet scene
var bullet_scene = preload("res://src/gunner/weapons/Bullet.tscn")
var bullet_impulse = 800
var fire_rate = 0.2
var bullet_knockback = 3

var fire_tween

func fire():
	firing = true

	if fire_tween and fire_tween.is_running():
		return

	fire_tween = create_tween()
	fire_bullet()
	fire_tween.set_loops(0)
	fire_tween.tween_callback(fire_bullet).set_delay(fire_rate)

func stop_firing():
	firing = false

	# kill tween after last bullet
	if fire_tween and fire_tween.is_running():
		fire_tween.kill()

signal fired_bullet(bullet)

func fire_bullet():
	if facing_vector == null:
		# TODO not sure why firing before moving falls flat
		facing_vector = Vector2.RIGHT
		update_facing()
	var bullet = bullet_scene.instantiate()
	bullet.position = bullet_position.get_global_position()
	bullet.add_collision_exception_with(self)
	Navi.current_scene.add_child.call_deferred(bullet)
	bullet.rotation = facing_vector.angle()
	bullet.apply_impulse(facing_vector * bullet_impulse, Vector2.ZERO)
	DJZ.play(DJZ.S.fire)
	fired_bullet.emit(bullet)

	# player push back when firing
	var pos = get_global_position()
	pos += -1 * facing_vector * bullet_knockback
	set_global_position(pos)


## sword #######################################################

func add_sword():
	# TODO add sword scene if one not found
	if not sword:
		Debug.warn("Refusing to add sword, none found")
		return
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
	if not has_sword or sword == null:
		return
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
