extends Control

## vars ############################################################33

@onready var player_status = $%PlayerStatus
@onready var level_opts_comp = $%LevelOpts
@onready var time_label = $%TimeLabel
@onready var weapon_list = $%WeaponList
var level_opts

## setters ############################################################33

func set_level_opts(opts: Dictionary):
	level_opts = opts

## _ready ############################################################33

func _ready():
	Dino.player_ready.connect(func(player):
		update_player_status()
		update_weapon_stack()
		if player and player.has_signal("changed_weapon"):
			player.changed_weapon.connect(func(_w):
				update_weapon_stack()))
	update_player_status()
	update_level_opts()
	update_weapon_stack()

	Hotel.entry_updated.connect(func(entry):
		# TODO maybe a bit noisy
		if "player" in entry.groups:
			update_player_status()
		, CONNECT_DEFERRED)

## updates ############################################################33

func update_player_status():
	var p_ent = Dino.current_player_entity()
	var p_node = Dino.current_player_node()

	if p_ent != null:
		var health = 0
		if p_node and is_instance_valid(p_node):
			health = p_node.health
		player_status.set_status({"entity": p_ent, "health": health})

func update_level_opts():
	if level_opts == null:
		return
	var s = level_opts.get("seed", 0)
	var ct = level_opts.get("room_count", 0)

	level_opts_comp.set_seed(s)
	level_opts_comp.set_room_count(ct)

func update_weapon_stack():
	var p = Dino.current_player_node()
	if p == null or not p.has_weapon():
		return

	# TODO rewrite as well-typed weapon_set func
	var ws: Array[DinoWeaponEntity] = []
	ws.assign(p.weapon_set.list_entities())
	weapon_list.entities = ws
	weapon_list.active_entity = p.active_weapon().entity
	weapon_list.render()

func update_time(t):
	time_label.text = "[center]%02d[/center]" % t
