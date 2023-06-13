@tool
extends TDBody
class_name TDPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var look_pof

var coins = 0

## config warning ###########################################################

func _get_configuration_warnings():
	var warns = super._get_configuration_warnings()
	var more = Util._config_warning(self, {expected_nodes=[
		"ActionDetector", "ActionHint", "LookPOF",
		]})
	warns.append_array(more)
	return warns

## enter tree ###########################################################

func _enter_tree():
	add_to_group("player", true)
	# TODO set usual collision layers/masks
	super._enter_tree()

## ready ###########################################################

func _ready():
	Util.set_optional_nodes(self, {
		look_pof="LookPOF",
		})

	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		# support some assigned 'hud'
		Hood.ensure_hud(self.get("hud"))

		# TODO could we just Actions.register(self) or Trolley.register(self)?
		# include opting into keybindings and current-ax updates
		action_detector.setup(self, {actions=[], action_hint=action_hint})

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
		# TODO could be a boolean callback on the state itself
		or machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		return

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
			# TODO restore strafing - check if using a weapon that supports strafing?
			# if not firing: # supports strafing (moving while firing without turning)
			if move_vector.x > 0:
				facing_vector = Vector2.RIGHT
			elif move_vector.x < 0:
				facing_vector = Vector2.LEFT
			update_facing()

## facing ###########################################################

func update_facing():
	super.update_facing()
	Util.update_h_flip(facing_vector, look_pof)

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
