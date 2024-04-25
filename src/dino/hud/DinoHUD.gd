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

## updates ############################################################33

func update_player_status():
	var p_ent = Dino.current_player_entity()

	if p_ent != null:
		player_status.set_status({"entity": p_ent})

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
