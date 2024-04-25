@tool
extends TDBody
class_name TDPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var look_pof

var boomerang

var coins = 0

var aim_vector = Vector2.ZERO

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

## ready ###########################################################

func _ready():
	U.set_optional_nodes(self, {
		look_pof="LookPOF",
		})

	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		action_detector.setup(self, {actions=[], action_hint=action_hint})

	set_collision_layer_value(1, false) # walls,doors,env
	set_collision_layer_value(2, true) # player
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true) # enemies
	set_collision_mask_value(5, true) # enemy projectiles
	set_collision_mask_value(6, true) # items
	set_collision_mask_value(11, true) # fences, low-walls
	set_collision_mask_value(12, true) # spikes

	super._ready()

## hotel data ##########################################################################

func hotel_data():
	var d = super.hotel_data()
	d["coins"] = coins
	return d

func check_out(data):
	super.check_out(data)
	coins = data.get("coins", coins)

## input ###########################################################

func _unhandled_input(event):
	# prevent input
	if block_control or is_dead \
		# could be a boolean callback on the state itself
		or machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		return

	# generic weapon
	if has_weapon() and Trolls.is_attack(event):
		use_weapon()
		# should strafe?
	elif has_weapon() and Trolls.is_attack_released(event):
		stop_using_weapon()
		# should stop strafe?

	if Trolls.is_event(event, "cycle_weapon"):
		cycle_weapon()

	# generic action
	if Trolls.is_action(event):
		stamp({scale=2.0, ttl=1.0, include_action_hint=true})
		action_detector.execute_current_action()
		action_detector.current_action()
		Cam.hitstop("player_hitstop", 0.5, 0.2)

	# action cycling
	if Trolls.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_prev_action()
	elif Trolls.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_next_action()


## physics_process ###########################################################

func _physics_process(delta):
	super._physics_process(delta)

	# checks forced_movement_target, then uses Trolls.move_vector
	var mv = get_move_vector()
	if mv != null:
		move_vector = mv

	if not Engine.is_editor_hint():
		if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
			update_facing()

		if move_vector.abs().length() > 0 and has_weapon():
			# maybe this just works?
			aim_vector = move_vector
			aim_weapon(aim_vector)

## facing ###########################################################

func update_facing():
	super.update_facing()
	U.update_h_flip(facing_vector, look_pof)

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
		return Trolls.move_vector()

func force_move_to_target(target_position):
	block_control = true
	forced_movement_target = target_position

func clear_forced_movement_target():
	block_control = false
	forced_movement_target = null

## pits ###################################################################

func on_pit_entered():
	machine.transit("Fall")
