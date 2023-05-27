@tool
extends SSPlayer

@onready var jet_anim = $Jet
@onready var notif_label = $NotifLabel

var gunner_hud = preload("res://src/gunner/hud/HUD.tscn")
# TODO support in tower's player class
var tower_hud = preload("res://src/tower/hud/HUD.tscn")

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({
			player=self,
			zoom_rect_min=400,
			proximity_min=100,
			proximity_max=450,
			})
		Hood.ensure_hud(gunner_hud)
	super._ready()

## hotel data ##########################################################################

func check_out(data):
	super.check_out(data)
	pickups = data.get("pickups", pickups)

func hotel_data():
	var d = super.hotel_data()
	d["pickups"] = pickups
	return d

## input ###########################################################

func _unhandled_input(event):
	super._unhandled_input(event)
	if not is_dead and Trolley.is_event(event, "fire") \
		and not machine.state.name in ["KnockedBack"]:
		fire()
	elif Trolley.is_event_released(event, "fire"):
		stop_firing()

## facing ###########################################################

@onready var look_pof = $LookPOF

func update_facing():
	super.update_facing()
	if move_vector.x > 0:
		if bullet_position.position.x < 0:
			bullet_position.position.x *= -1

		if look_pof.position.x < 0:
			look_pof.position.x *= -1
	elif move_vector.x < 0:
		if bullet_position.position.x > 0:
			bullet_position.position.x *= -1

		if look_pof.position.x > 0:
			look_pof.position.x *= -1


## fire ###########################################################

@onready var bullet_position = $BulletPosition
var firing = false

# per-bullet (gun) numbers

var bullet_scene = preload("res://src/gunner/weapons/Bullet.tscn")
var bullet_impulse = 800
var fire_rate = 0.2
var bullet_knockback = 2

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

	# push player back when firing
	var pos = get_global_position()
	pos += -1 * facing_vector * bullet_knockback
	set_global_position(pos)


## notif #####################################################################

func notif(text, opts = {}):
	Debug.pr("notif", text)

	var ttl = opts.get("ttl", 1.5)
	var dupe = opts.get("dupe", false)
	var label
	if dupe:
		label = notif_label.duplicate()
	else:
		label = notif_label

	label.text = "[center]" + text
	label.set_visible(true)
	var tween = create_tween()
	if dupe:
		label.set_global_position(notif_label.get_global_position())
		Navi.add_child_to_current(label)
		tween.tween_callback(label.queue_free).set_delay(ttl)
	else:
		tween.tween_callback(label.set_visible.bind(false)).set_delay(ttl)


## level up #####################################################################

func level_up():
	shine(2.0)
	notif("LEVEL UP", {"dupe": true})
	Hood.notif("Level Up")

func shine(_time = 1.0):
	pass
	# var tween = create_tween()
	# anim.material.set("shader_parameter/speed", 1.0)
	# tween.tween_callback(anim.material.set.bind("shader_parameter/speed", 0.0)).set_delay(time)


## pickups #####################################################################

var pickups = []

signal pickups_changed(pickups)


func collect_pickup(pickup_type):
	notif(pickup_type.capitalize() + " PICKED UP", {"dupe": true})
	if pickup_type == "jetpack":
		has_jetpack = true
	else:
		pickups.append(pickup_type)
		pickups_changed.emit(pickups)

	Hotel.check_in(self, {pickups=pickups})

## tile color detection #####################################################################

var current_tile_colors = []


func _on_TileAOEDetector_body_entered(body: Node):
	if body.is_in_group("yellowtile"):
		current_tile_colors.append("yellow")
	elif body.is_in_group("bluetile"):
		current_tile_colors.append("blue")
	elif body.is_in_group("redtile"):
		current_tile_colors.append("red")
	update_colors()
	update_aoe_state()


func _on_TileAOEDetector_body_exited(body: Node):
	if body.is_in_group("yellowtile"):
		current_tile_colors.erase("yellow")
	elif body.is_in_group("bluetile"):
		current_tile_colors.erase("blue")
	elif body.is_in_group("redtile"):
		current_tile_colors.erase("red")
	update_colors()
	update_aoe_state()


var coldfire_dark = Color8(70, 66, 94)
var coldfire_blue = Color8(91, 118, 141)
var coldfire_red = Color8(209, 124, 124)
var coldfire_yellow = Color8(246, 198, 168)


func update_colors():
	var tween = create_tween()
	if current_tile_colors:
		var color = current_tile_colors[0]

		match color:
			"red":
				tween.tween_property(anim.material, "shader_parameter/outline", coldfire_dark, 0.4)
				tween.parallel().tween_property(
					anim.material, "shader_parameter/accent", coldfire_yellow, 0.4
				)
			"yellow":
				tween.tween_property(anim.material, "shader_parameter/outline", coldfire_dark, 0.4)
				tween.parallel().tween_property(
					anim.material, "shader_parameter/accent", coldfire_red, 0.4
				)
			"blue":
				tween.tween_property(anim.material, "shader_parameter/outline", coldfire_yellow, 0.4)
				tween.parallel().tween_property(
					anim.material, "shader_parameter/accent", coldfire_dark, 0.4
				)
	else:
		tween.tween_property(anim.material, "shader_parameter/outline", coldfire_dark, 0.4)
		tween.parallel().tween_property(anim.material, "shader_parameter/accent", coldfire_yellow, 0.4)


var in_blue = false
var in_red = false


func update_aoe_state():
	var was_blue = in_blue
	if "blue" in current_tile_colors:
		in_blue = true
		if not was_blue:
			notif("BRRRRRRRRRR")
			Hood.notif("Jetpack power reduced")
	else:
		in_blue = false
		if was_blue:
			Hood.notif("Jetpack power restored")

	var was_red = in_red
	if "red" in current_tile_colors:
		in_red = true
		if not was_red:
			notif("HOT HOT HOT")
			Hood.notif("Jetpack supercharged")
	else:
		in_red = false
		if was_red:
			Hood.notif("Jetpack power restored")
