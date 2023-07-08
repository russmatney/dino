extends SSPlayer

func _get_configuration_warnings():
	return super._get_configuration_warnings()

@export var zoom_rect_min = 200
@export var zoom_margin_min = 100

## ready ##################################################################

var hud = preload("res://src/spike/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})
		Hood.ensure_hud(hud)

	super._ready()

	for p in pickups:
		add_orbit_item(p)

## hotel ##################################################################

# func check_out(data):
# 	super.check_out(data)
# 	shrine_gems = Util.get_(data, "shrine_gems", shrine_gems)

# func hotel_data():
# 	var d = super.hotel_data()
# 	d["shrine_gems"] = shrine_gems
# 	return d

## process ##################################################################

func _process(_delta):
	# super._process(delta)
	if orbit_items.size() == 0:
		remove_orbit_item_weapon()
	else:
		if not orbit_item_weapon or not orbit_item_weapon in weapons:
			add_orbit_item_weapon()

## orbiting items ##################################################################

func collect_pickup(pickup_type):
	super.collect_pickup(pickup_type)
	add_orbit_item(pickup_type)

@onready var orbit_item_scene = preload("res://src/spike/entities/OrbitItem.tscn")

var orbit_items = []

func add_orbit_item(pickup_type):
	Debug.pr("adding orbit item", pickup_type)

	var item = orbit_item_scene.instantiate()
	item.show_behind_parent = true
	item.pickup_type = pickup_type
	# TODO set with pickup type
	add_child.call_deferred(item)
	orbit_items.append(item)

func remove_orbit_item(pickup):
	pickups.erase(pickup)
	var its = get_children().filter(func(c): return "pickup_type" in c and c.pickup_type == pickup)
	if its.size() > 0:
		var it = its[0]
		orbit_items.erase(it)
		it.queue_free()

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
