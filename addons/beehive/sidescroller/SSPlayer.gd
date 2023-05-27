@tool
extends SSBody
class_name SSPlayer

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var look_pof
var bullet_position

@export var has_gun: bool

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

## ready ###########################################################

var actions = []

func _ready():
	# TODO util to dry up this assignment logic
	if get_node_or_null("LookPOF"):
		look_pof = $LookPOF
	if get_node_or_null("BulletPosition"):
		bullet_position = $BulletPosition

	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		# support some assigned 'hud'
		Hood.ensure_hud(self.get("hud"))

		# TODO could we just Actions.register(self) or Trolley.register(self)?
		# include opting into keybindings and current-ax updates
		action_detector.setup(self, {actions=actions, action_hint=action_hint,
			can_execute_any=func(): return machine and not machine.state.name in ["Rest"]})

	super._ready()

## input ###########################################################

func _unhandled_input(event):
	# TODO move controls into the states?
	if not is_dead and has_jetpack \
		and Trolley.is_event(event, "jetpack"):
		machine.transit("Jetpack")
	if not is_dead and has_gun and Trolley.is_event(event, "fire") \
		and not machine.state.name in ["KnockedBack"]:
		fire()
	elif has_gun and Trolley.is_event_released(event, "fire"):
		stop_firing()

	if Trolley.is_action(event):
		stamp({scale=2.0, ttl=1.0, include_action_hint=true})
		action_detector.execute_current_action()
		action_detector.current_action()
		Cam.hitstop("player_hitstop", 0.5, 0.2)

	if Trolley.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_prev_action()
	elif Trolley.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_next_action()


## physics_process ###########################################################

func _physics_process(_delta):
	# super._physics_process(delta)

	move_vector = Trolley.move_vector()

	if not Engine.is_editor_hint():
		if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
			if not firing: # supports strafing (moving while firing without turning)
				if move_vector.x > 0:
					facing_vector = Vector2.RIGHT
				elif move_vector.x < 0:
					facing_vector = Vector2.LEFT
			update_facing()

## facing ###########################################################

func update_facing():
	super.update_facing()
	Util.update_h_flip(facing_vector, bullet_position)
	Util.update_h_flip(facing_vector, look_pof)

## gun/fire/bullets ###########################################################

func add_gun():
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
