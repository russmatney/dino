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

		# could be instances with randomized stats, etc
		add_weapon(DinoWeaponEntityIds.GUN)
		add_weapon(DinoWeaponEntityIds.BOOMERANG)
		add_weapon(DinoWeaponEntityIds.FLASHLIGHT)
		add_weapon(DinoWeaponEntityIds.SWORD)
		has_double_jump = true

	super._ready()


func _on_player_death():
	stamp({ttl=0}) # perma stamp

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	if light:
		t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

## collect ##################################################################

func collect(_entity, _opts={}):
	pass
	# match entity.type:
	# 	WoodsEntity.t.Leaf: Log.pr("player collected leaf")

## process ##################################################################

var is_spiking = false

func _process(_delta):
	# TODO don't fire these every process loop!
	if has_weapon_id(DinoWeaponEntityIds.ORBS):
		if orbit_items.size() == 0 and is_spiking == false:
			remove_weapon_by_id(DinoWeaponEntityIds.ORBS)
	if not has_weapon_id(DinoWeaponEntityIds.ORBS):
		if orbit_items.size() > 0:
			add_weapon(DinoWeaponEntityIds.ORBS)

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

## spiking ##################################################################

func in_spike_zone():
	return true
