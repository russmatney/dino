extends CharacterBody2D
class_name TDPlayer

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"TDPlayerMachine", "StateLabel", "AnimatedSprite2D",
		"ActionDetector", "ActionHint",
		], expected_animations={"AnimatedSprite2D": [
			"idle_down", "idle_up", "idle_right",
			"run_down", "run_up", "run_right",]}})

## vars ###########################################################

# player config

@export var display_name: String
@export var initial_health: int = 6

@export var run_speed: float = 10000
@export var wander_speed: float = 6000
@export var jump_speed: float = 10000

# runtime vars

var move_vector: Vector2
var facing_vector: Vector2
var health
var aim_vector = Vector2.ZERO
var is_dead
var grabbing

# pickups

var coins = 0
var shrine_gems = 0

# weapons

signal changed_weapon(weapon)
var weapon_set: WeaponSet = WeaponSet.new("td")

# nodes

@onready var coll = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var machine = $TDPlayerMachine
@onready var state_label = $StateLabel
@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

var action_label
var action_arrow

var produce_icon
var seed_icon
var seed_type_icon
var tool_icon

var item_seed
var item_tool
var item_produce

var notif_label
var hurt_box
var pit_detector
var heart_particles
var skull_particles

var quick_select_scene = preload("res://src/components/quick_select/QuickSelect.tscn")
var quick_select_menu

var player_camera_scene = preload("res://src/dino/players/PlayerCamera.tscn")
var pcam: PhantomCamera2D

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
		notif_label="NotifLabel",
		hurt_box="HurtBox",
		heart_particles="HeartParticles",
		skull_particles="SkullParticles",
		pit_detector="PitDetector",
		quick_select_menu="QuickSelect",
		action_label="ActionLabel",
		action_arrow="ActionArrow",
		produce_icon="Item/ProduceIcon",
		seed_icon="Item/SeedIcon",
		seed_type_icon="Item/SeedIcon/SeedTypeIcon",
		tool_icon="Item/ToolIcon",
		})

	if hurt_box:
		hurt_box.body_entered.connect(on_hurt_box_entered)
		hurt_box.body_exited.connect(on_hurt_box_exited)

	if heart_particles:
		heart_particles.set_emitting(false)
	if skull_particles:
		skull_particles.set_emitting(false)

	machine.transitioned.connect(_on_transit)

	weapon_set.changed_weapon.connect(func(w):
		changed_weapon.emit(w))

	set_collision_layer_value(1, false) # walls,doors,env
	set_collision_layer_value(2, true) # player
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true) # enemies
	set_collision_mask_value(5, true) # enemy projectiles
	set_collision_mask_value(6, true) # items
	set_collision_mask_value(11, true) # fences, low-walls
	set_collision_mask_value(12, true) # spikes

	if quick_select_menu == null:
		quick_select_menu = quick_select_scene.instantiate()
		add_child(quick_select_menu)
	quick_select_menu.hide_menu()

	add_weapon(DinoWeaponEntityIds.BOOMERANG)

	state_label.set_visible(false)

## actions ###########################################################

var actions = []

func can_execute_any():
	return machine and machine.can_act()

## hotel data ##########################################################################

func hotel_data():
	var d = {health=health, name=name, is_dead=is_dead}
	if not display_name in ["", null]: # yay types! woo!
		d["display_name"] = display_name
	d["coins"] = coins
	d["shrine_gems"] = coins
	return d

func check_out(data):
	health = U.get_(data, "health", initial_health)
	is_dead = U.get_(data, "is_dead", is_dead)
	display_name = U.get_(data, "display_name", display_name)
	coins = data.get("coins", coins)
	shrine_gems = data.get("shrine_gems", shrine_gems)

## shrine_gems #######################################################

func has_shrine_gems(n):
	return shrine_gems >= n

func add_shrine_gem():
	shrine_gems += 1

## on_transit ###########################################################

func _on_transit(label):
	state_label.text = "[center]%s" % label

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
		Juice.hitstop({name="player_hitstop", time_scale=0.5, duration=0.2})

	# action cycling
	if Trolls.is_cycle_prev_action(event):
		Sounds.play(Sounds.S.walk)
		action_detector.cycle_prev_action()
	elif Trolls.is_cycle_next_action(event):
		Sounds.play(Sounds.S.walk)
		action_detector.cycle_next_action()

## physics_process ###########################################################

func _physics_process(_delta):
	# checks forced_movement_target, then uses Trolls.move_vector
	var mv = get_move_vector()
	if mv != null:
		move_vector = mv

	if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
		update_facing()

	if move_vector.abs().length() > 0 and has_weapon():
		# maybe this just works?
		aim_vector = move_vector
		aim_weapon(aim_vector)

## process ###########################################################

func _process(_delta):
	update_action_label()
	point_arrow()

	# herd player had this, maybe to keep the current action updating?
	# action_detector.current_action()

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
	# TODO damage?
	machine.transit("Fall")

	# await get_tree().create_timer(1.0).timeout
	# Dino.respawn_player({player=self})

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

	stamp({ttl=0}) # perma stamp

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	# if light:
	# 	t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

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
# var is_invincible = false

func on_hurt_box_entered(body):
	# if is_invincible:
	# 	return
	if not "is_td_body" in body:
		return
	if not body.is_dead and not body.machine.state.name in ["KnockedBack", "Dying", "Dead"]:
		if not body in hurt_box_bodies:
			hurt_box_bodies.append(body)
			self.take_hit({type="bump", body=body})

			# is_invincible = true
			# await get_tree().create_timer(1.0).timeout
			# is_invincible = false
			# hurt_box_bodies = []

func on_hurt_box_exited(body):
	hurt_box_bodies.erase(body)

######################################################
# grab/throw

func can_grab():
	return grabbing == null

func grab(node):
	Sounds.play(Sounds.S.candleout)
	grabbing = node
	U._connect(node.died, on_grabbing_died)

func throw(_node):
	Sounds.play(Sounds.S.laser)
	grabbing.died.disconnect(on_grabbing_died)
	grabbing = null
	# could pass throw_speed/weight
	return {direction=facing_vector}

func on_grabbing_died(_node):
	grabbing = null


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

func aim_weapon(aim_v: Vector2):
	return weapon_set.aim_weapon(aim_v)

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

## point_arrow ###########################################################

func point_arrow():
	if action_detector.actions.size() == 0:
		action_arrow.set_visible(false)
		return
	action_arrow.set_visible(true)

	var ax = action_detector.nearest_action()
	if ax and ax.source:
		var rot = get_angle_to(ax.source.get_global_position()) + (PI / 2)
		action_arrow.set_rotation(rot)

## action detection ###########################################################

func update_action_label():
	if not action_label:
		return

	var ax = action_detector.nearest_action()

	if ax == null:
		action_label.text = ""
		return

	action_label.text = "[center]" + ax.label.capitalize() + "[/center]"

	# fade label if action is not current (i.e. not possible?) bit of naming could help here
	if action_detector.current_action():
		action_label.modulate.a = 1
	elif action_detector.find_nearest(action_detector.potential_actions()):
		action_label.modulate.a = 0.7
	else:
		action_label.modulate.a = 0.4

## harvey ###########################################################

## items ###########################################################

func drop_held_item():
	produce_icon.set_visible(false)
	seed_icon.set_visible(false)
	tool_icon.set_visible(false)

	item_seed = null
	item_tool = null
	item_produce = null

func pickup_seed(produce_type):
	drop_held_item()
	seed_icon.set_visible(true)
	seed_type_icon.animation = produce_type
	item_seed = produce_type

func pickup_produce(produce_type):
	drop_held_item()
	produce_icon.set_visible(true)
	produce_icon.animation = produce_type
	item_produce = produce_type

func pickup_tool(tool_type):
	drop_held_item()
	tool_icon.set_visible(true)
	tool_icon.animation = tool_type
	item_tool = tool_type

## seeds ###########################################################

func has_seed():
	if item_seed:
		return true
	else:
		return false

func plant_seed():
	var type = item_seed

	item_seed = null
	drop_held_item()

	return type

## tools, water ###########################################################

func has_tool():
	if item_tool:
		return true
	else:
		return false

func has_water():
	if item_tool == "watering-pail":
		return true
	else:
		return false

func water_plant():
	pass

func action_source_needs_water():
	for src in action_detector.actions.map(func(ax): return ax.source):
		if src.has_method("needs_water"):
			if src.needs_water():
				return true

## produce ############################################################

func harvest_produce(produce_type):
	pickup_produce(produce_type)

func has_produce():
	if item_produce:
		return true
	else:
		return false

signal produce_delivered(item_produce)

func deliver_produce():
	produce_delivered.emit(item_produce)
	drop_held_item()
