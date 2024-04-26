extends CharacterBody2D
class_name SSPlayer

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"SSMachine", "StateLabel", "AnimatedSprite2D",
		"ActionDetector", "ActionHint", "LookPOF",
		], expected_animations={"AnimatedSprite2D": [
			"idle", "run", "jump", "air", "fall",
			"knocked_back", "dying", "dead",]}})

## data ##########################################################

enum Powerup { Read, Sword, Flashlight, DoubleJump, Climb, Gun, Jetpack, Ascend, Descend,
	Bow, Boomerang,
	}
static var all_powerups = [
	Powerup.DoubleJump,
	Powerup.Climb,
	Powerup.Jetpack,
	Powerup.Flashlight,
	Powerup.Sword, Powerup.Gun,
	Powerup.Ascend, Powerup.Descend,
	Powerup.Bow, Powerup.Boomerang,
	]

## vars ###########################################################

# input vars

@export var display_name: String
@export var initial_health: int = 6
@export var bump_damage: int = 2
@export var defense: int = 1

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

var powerups = []

# weapons
var weapon_set: WeaponSet = WeaponSet.new("ss")
var aim_vector = Vector2.ZERO

var orbit_items = []

# pickups
var pickups = []

var coins = 0
var leaves = 0

# actor vars

var move_vector: Vector2
var facing_vector: Vector2

var is_spiking: bool = false
var block_controls = false
var forced_movement_target
var forced_movement_target_threshold = 10

var health: int
var is_dead: bool
var death_count: int = 0

# nodes

@onready var coll = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var machine: Machine = $SSMachine
@onready var state_label: RichTextLabel = $StateLabel
@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var jet_anim
var cam_pof
var bumpbox
var nav_agent
var notif_label
var warp_cast

var look_pof
var light
var light_occluder

var high_wall_check
var low_wall_check
var wall_checks = []
var near_ground_check

var heart_particles
var skull_particles

# child scenes

var quick_select_scene = preload("res://src/components/quick_select/QuickSelect.tscn")
var quick_select_menu

var player_camera_scene = preload("res://src/dino/players/PlayerCamera.tscn")
var pcam: PhantomCamera2D

var orbit_item_scene = preload("res://src/dino/weapons/orb/OrbitItem.tscn")

## signals ###########################################################

signal died()
signal changed_weapon(weapon)
signal pickups_changed(pickups)

## enter tree ###########################################################

func _enter_tree():
	add_to_group("player", true)
	ensure_pcam()

## ready ###########################################################

func ensure_pcam():
	pcam = get_node_or_null("PlayerCamera")
	if pcam == null:
		pcam = player_camera_scene.instantiate()
		add_child(pcam)
		pcam.set_owner(self)

func _ready():
	Hotel.register(self)

	U.set_optional_nodes(self, {
		jet_anim="Jet",
		notif_label="NotifLabel",
		pcam="PlayerCamera",
		cam_pof="CamPOF",
		nav_agent="NavigationAgent2D",
		bumpbox="BumpBox",
		high_wall_check="HighWallCheck",
		low_wall_check="LowWallCheck",
		near_ground_check="NearGroundCheck",
		heart_particles="HeartParticles",
		skull_particles="SkullParticles",
		warp_cast="WarpCast",
		look_pof="LookPOF",
		light_occluder="LightOccluder2D",
		light="PointLight2D",
		quick_select_menu="QuickSelect"
		})

	if bumpbox:
		bumpbox.body_entered.connect(on_bumpbox_entered)
		bumpbox.body_exited.connect(on_bumpbox_exited)
	if high_wall_check or low_wall_check:
		wall_checks = [high_wall_check, low_wall_check]
	if heart_particles:
		heart_particles.set_emitting(false)
	if skull_particles:
		skull_particles.set_emitting(false)

	machine.transitioned.connect(_on_transit)

	weapon_set.changed_weapon.connect(func(w):
		changed_weapon.emit(w))

	died.connect(_on_player_death)

	var level = U.find_level_root(self)
	if level.has_method("_on_player_death"):
		died.connect(level._on_player_death.bind(self))

	# could be instances with randomized stats, etc
	add_weapon(DinoWeaponEntityIds.FLASHLIGHT)
	add_weapon(DinoWeaponEntityIds.SWORD)
	add_weapon(DinoWeaponEntityIds.GUN)
	add_weapon(DinoWeaponEntityIds.BOOMERANG)
	add_powerup(Powerup.DoubleJump)
	add_powerup(Powerup.Jetpack)

	set_collision_layer_value(1, false) # walls,doors,env
	set_collision_layer_value(2, true) # player
	set_collision_mask_value(1, true) # sense walls/doors/tiles
	set_collision_mask_value(4, true) # enemies
	set_collision_mask_value(5, true) # enemy projectiles
	set_collision_mask_value(6, true) # items
	set_collision_mask_value(11, true) # fences, low-walls
	set_collision_mask_value(12, true) # spikes

	if quick_select_menu == null:
		quick_select_menu = quick_select_scene.instantiate()
		add_child(quick_select_menu)
	quick_select_menu.hide_menu()

	state_label.set_visible(false)

## input ###########################################################

func _unhandled_input(event):
	# prevent input
	if block_controls or is_dead or machine.ignore_input():
		Log.info("blocking ss player control")
		return

	# jetpack
	if has_jetpack and Trolls.is_jetpack(event):
		machine.transit("Jetpack")

	# dash
	if has_dash and Trolls.is_dash(event) and not machine.state.name in ["Dash"]:
		machine.transit("Dash")

	# generic weapon
	if has_weapon() and Trolls.is_attack(event):
		use_weapon()
		# should strafe?
	elif has_weapon() and Trolls.is_attack_released(event):
		stop_using_weapon()
		# should stop strafe?

	if Trolls.is_pressed(event, "weapon_swap_menu"):
		quick_select_menu.show_menu({
			entities=weapon_set.list_entities(),
			on_select=func(weapon):
			activate_weapon(weapon),
			})
	elif Trolls.is_released(event, "weapon_swap_menu"):
		quick_select_menu.hide_menu()

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

func _physics_process(_delta):
	# checks forced_movement_target, then uses Trolls.move_vector
	move_vector = get_move_vector()

	if move_vector.abs().length() > 0 and machine.face_movement_direction():
		# restore strafing - check if using a weapon that supports strafing?
		# if not firing: # supports strafing (moving while firing without turning)
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()

	if move_vector.abs().length() > 0 and has_weapon():
		aim_vector = move_vector
		aim_weapon(aim_vector)

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

func can_execute_any():
	return machine and machine.can_act()

## collision check ###########################################################

# Should be called immediately after move_and_slide in physics_process
# if it returns true, the calling physics_process should return to avoid moving to another state
func collision_check():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("spikes"):
			take_hit({body=collider, damage=1, type="spikes"})
			return true

## rect ###########################################################

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
	var d = {
		health=health,
		name=name,
		is_dead=is_dead,
		death_count=death_count,
		powerups=powerups,
		coins=coins,
		leaves=leaves,
		pickups=pickups,
		}
	if not display_name in ["", null]: # yay types! woo!
		d["display_name"] = display_name
	return d

func check_out(data):
	health = U.get_(data, "health", initial_health)
	is_dead = U.get_(data, "is_dead", is_dead)
	display_name = U.get_(data, "display_name", display_name)
	death_count = U.get_(data, "death_count", death_count)
	coins = U.get_(data, "coins", coins)
	leaves = U.get_(data, "leaves", leaves)
	pickups = U.get_(data, "pickups", pickups)
	var stored_powerups = U.get_(data, "powerups", powerups)
	if len(stored_powerups) > 0:
		powerups = stored_powerups

	for p in powerups:
		update_with_powerup(p)

## facing ###########################################################

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
	# could we just flip the parent x-scale ?!?

	# all art should face RIGHT by default
	anim.flip_h = facing_vector == Vector2.LEFT
	update_los_facing(facing_vector, high_wall_check)
	update_los_facing(facing_vector, low_wall_check)

	# flip weapons
	for w in weapon_set.list().filter(func(w): return w.should_flip):
		U.update_h_flip(facing_vector, w)

	U.update_h_flip(facing_vector, look_pof)
	U.update_h_flip(facing_vector, light_occluder)

func flip_facing():
	# assumes facing vector is always vec.left or vec.right
	facing_vector *= -1
	update_facing()

func face_body(body):
	if not body:
		return
	var pos_diff = body.global_position - global_position
	if pos_diff.x > 0:
		facing_vector = Vector2.RIGHT
	elif pos_diff.x < 0:
		facing_vector = Vector2.LEFT

	update_facing()

## death ###########################################################

func die(_opts={}):
	is_dead = true
	death_count += 1
	Hotel.check_in(self)

func resurrect():
	is_dead = false
	health = initial_health
	Hotel.check_in(self)

func _on_player_death():
	stamp({ttl=0}) # perma stamp

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	if light:
		t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

## damage ###########################################################

func take_hit(opts):
	take_damage(opts)
	var hit_type = opts.get("type")
	var body = opts.get("body")
	var _dir = opts.get("direction")

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

	# TODO factor in 'defense'
	if damage == null:
		match hit_type:
			"bump":
				if "bump_damage" in body and body.bump_damage != null:
					damage = body.bump_damage
				else:
					damage = 1
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

## hurtbox ###########################################################

var bumpbox_bodies = []

# player hurting another body by touching...
func on_bumpbox_entered(body):
	if not body.is_dead and body.machine.can_bump():
		if not body in bumpbox_bodies:
			bumpbox_bodies.append(body)
			body.take_hit({type="bump", body=self})

func on_bumpbox_exited(body):
	bumpbox_bodies.erase(body)

#################################################################################
## forced movement/blocking controls ############################################

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
	block_controls = true
	forced_movement_target = target_position

func clear_forced_movement_target():
	block_controls = false
	forced_movement_target = null

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
		U.add_child_to_level(self, label)
		notif_tween.tween_callback(label.queue_free).set_delay(ttl)
	else:
		notif_tween.tween_callback(label.set_visible.bind(false)).set_delay(ttl)

## level up #####################################################################

func level_up():
	shine(2.0)
	notif("LEVEL UP", {"dupe": true})
	Debug.notif("Level Up")

## shine #####################################################################

func shine(_time = 1.0):
	pass
	# var tween = create_tween()
	# anim.material.set("shader_parameter/speed", 1.0)
	# tween.tween_callback(anim.material.set.bind("shader_parameter/speed", 0.0)).set_delay(time)

## stamp ##########################################################################

# Supports 'perma-stamp' with ttl=0
func stamp(opts={}):
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

#################################################################################
## pickups #####################################################################

func collect(opts={}):
	var data = opts.get("data")

	if not data:
		Log.warn("Unhandled pickup", opts)
		return

	match data.type:
		DropData.T.RANDOM:
			Log.warn("Unhandled pickup", opts)
		DropData.T.ORB:
			add_orb(SpikeData.Ingredient.RedBlob)
			Dino.notif({
				type="popup",
				header_text="Orb Acquired",
				body_text="This looks like a mighty fine ingredient",
				})
			return
		DropData.T.COIN:
			Dino.notif({
				type="side",
				text="+1 coin",
				id="add-coin"
				})
			add_coin()
			return
		DropData.T.LEAF:
			Dino.notif({
				type="side",
				text="+1 leaf",
				id="add-leaf"
				})
			add_leaf()
			return
		DropData.T.POWERUP:
			Log.warn("Unhandled pickup", opts)
			Dino.notif({
				type="popup",
				header_text="Powerup Acquired",
				body_text="A very good description of a powerup",
				})
		_:
			pass

	Log.warn("unhandled pickup", opts)

## counts

func add_coin():
	notif("COIN PICKED UP", {"dupe": true})
	coins += 1
	Hotel.check_in(self)

func add_leaf():
	notif("LEAF PICKED UP", {"dupe": true})
	leaves += 1
	Hotel.check_in(self)

func add_orb(ingredient_type):
	add_orbit_item(ingredient_type)

## items

func add_pickup(data):
	pickups.append(data)

	Hotel.check_in(self, {pickups=pickups})
	pickups_changed.emit(pickups)


#################################################################################
## Powerups #####################################################################

func update_with_powerup(powerup: Powerup):
	match (powerup):
		# weapons
		Powerup.Sword: add_weapon(DinoWeaponEntityIds.SWORD)
		Powerup.Flashlight: add_weapon(DinoWeaponEntityIds.FLASHLIGHT)
		Powerup.Gun: add_weapon(DinoWeaponEntityIds.GUN)
		Powerup.Bow: add_weapon(DinoWeaponEntityIds.BOW)
		Powerup.Boomerang: add_weapon(DinoWeaponEntityIds.BOOMERANG)

		# powerups
		Powerup.Ascend: add_ascend()
		Powerup.Descend: add_descend()
		Powerup.DoubleJump: add_double_jump()
		Powerup.Climb: add_climb()
		Powerup.Jetpack: add_jetpack()

func add_powerup(powerup: Powerup):
	powerups.append(powerup)
	update_with_powerup(powerup)
	Hotel.check_in(self)

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
		var coll_obj = get_slide_collision(0)
		var x_diff = coll_obj.get_position().x - global_position.x

		if move_vector.x > 0 and x_diff > 0:
			return true
		if move_vector.x < 0 and x_diff < 0:
			return true
	return false

## dash #######################################################

func add_dash():
	has_dash = true

## jetpack #######################################################

func add_jetpack():
	has_jetpack = true

## ascend/descend #######################################################

func add_ascend():
	if not warp_cast:
		Log.warn("refusing to add ascend powerup")
		return
	has_ascend = true

func add_descend():
	if not warp_cast:
		Log.warn("refusing to add descend powerup")
		return
	has_descend = true

#################################################################################
## weapons #######################################################

func add_weapon(ent_id):
	var w = weapon_set.add_weapon(ent_id)
	if w:
		# no new child returned if weapon_ent already exists on a weapon
		add_child(w)

func remove_weapon_by_id(ent_id):
	var w = weapon_set.remove_weapon_by_id(ent_id)
	if w:
		remove_child(w)
		w.queue_free()

func has_weapon():
	return weapon_set.has_weapon()

func has_weapon_id(ent_id):
	return weapon_set.has_weapon_id(ent_id)

func active_weapon():
	return weapon_set.active_weapon()

func aim_weapon(aim_vec):
	return weapon_set.aim_weapon(aim_vec)

func cycle_weapon():
	return weapon_set.cycle_weapon()

func activate_weapon(entity):
	return weapon_set.activate_weapon_with_entity(entity)

# Uses the first weapon if none is passed
func use_weapon(weapon=null):
	return weapon_set.use_weapon(weapon)

# i.e. button released, stop firing or whatever continuous action
func stop_using_weapon(weapon=null):
	return weapon_set.stop_using_weapon(weapon)

func add_orbit_item(ingredient_type):
	var item = orbit_item_scene.instantiate()
	item.show_behind_parent = true
	# pass ingredient data along
	item.ingredient_type = ingredient_type
	add_child.call_deferred(item)
	orbit_items.append(item)

	if not has_weapon_id(DinoWeaponEntityIds.ORBS):
		add_weapon(DinoWeaponEntityIds.ORBS)

func remove_tossed_orbit_item(item):
	for ch in get_children():
		if ch == item:
			orbit_items.erase(ch)
			ch.queue_free()

			# dowe care if spiking?
			if orbit_items.size() == 0:
				remove_weapon_by_id(DinoWeaponEntityIds.ORBS)

## spiking ##################################################################

func in_spike_zone():
	return true
