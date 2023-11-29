@tool
extends SSPlayer

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({
			player=self,
			zoom_rect_min=400,
			proximity_min=100,
			proximity_max=450,
			})

		died.connect(_on_player_death)

		var level = U.find_level_root(self)
		if level.has_method("_on_player_death"):
			died.connect(level._on_player_death.bind(self))

	has_gun = true
	has_boomerang = true
	has_double_jump = true

	# has_climb = true
	# has_jetpack = true
	# has_dash = false

	super._ready()


func _on_player_death():
	stamp({ttl=0}) # perma stamp

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	if light:
		t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

## collect ##################################################################

# TODO promote to SSPlayer so other players can do this
func collect(_entity, _opts={}):
	pass
	# match entity.type:
	# 	WoodsEntity.t.Leaf: Log.pr("player collected leaf")

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
	Log.pr("adding orbit item", ingredient_type)

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
