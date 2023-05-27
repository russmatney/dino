@tool
extends SSPlayer

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

## pickups #####################################################################

# TODO items abstraction, powerups handling
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
