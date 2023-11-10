@tool
extends SSPlayer

func _get_configuration_warnings():
	return super._get_configuration_warnings()

@export var zoom_rect_min = 200
@export var zoom_margin_min = 100

## ready ##################################################################

var hud = preload("res://src/spike/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

		died.connect(_on_player_death)

	super._ready()

func _on_player_death():
	stamp({ttl=0}) # perma stamp

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	if light:
		t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

	# possibly we could share/re-use this, but meh, it'll probably need specific text
	Jumbotron.jumbo_notif({header="You died", body="Sorry about it!",
		action="close", action_label_text="Respawn",
		on_close=Game.respawn_player.bind({
			setup_fn=func(p):
			Hotel.check_in(p, {health=p.initial_health, is_dead=false})})})

## hotel ##################################################################

# func check_out(data):
# 	super.check_out(data)

# func hotel_data():
# 	var d = super.hotel_data()
# 	return d

## process ##################################################################

var is_spiking = false

func _process(_delta):
	# super._process(delta)
	if orbit_items.size() == 0 and is_spiking == false:
		remove_orbit_item_weapon()
	else:
		if not orbit_item_weapon or not orbit_item_weapon in weapons:
			add_orbit_item_weapon()

## orbiting items ##################################################################

func collect_pickup(ingredient_type):
	# overriding ssplayer pickup logic
	add_orbit_item(ingredient_type)

@onready var orbit_item_scene = preload("res://src/spike/entities/OrbitItem.tscn")

var orbit_items = []

func add_orbit_item(ingredient_type):
	Debug.pr("adding orbit item", ingredient_type)

	var item = orbit_item_scene.instantiate()
	item.show_behind_parent = true
	# pass ingredient data along
	item.ingredient_type = ingredient_type
	add_child.call_deferred(item)
	orbit_items.append(item)

func remove_orbit_item(item):
	for ch in get_children():
		if ch == item:
			orbit_items.erase(ch)
			ch.queue_free()

@onready var orbit_item_weapon_scene = preload("res://src/spike/entities/OrbitItemWeapon.tscn")
var orbit_item_weapon

func add_orbit_item_weapon():
	if not orbit_item_weapon:
		orbit_item_weapon = orbit_item_weapon_scene.instantiate()
		add_child(orbit_item_weapon)
	add_weapon(orbit_item_weapon)

func remove_orbit_item_weapon():
	if orbit_item_weapon:
		drop_weapon(orbit_item_weapon)
		orbit_item_weapon.visible = false


## spiking ##################################################################

func in_spike_zone():
	return true
