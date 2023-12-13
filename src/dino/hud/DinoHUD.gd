extends CanvasLayer

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
	P.player_ready.connect(func():
		update_player_status()
		update_weapon_stack()
		if P.player and P.player.has_signal("changed_weapon"):
			P.player.changed_weapon.connect(func(_w):
				update_weapon_stack()))
	update_player_status()
	update_level_opts()
	update_weapon_stack()

## updates ############################################################33

func update_player_status():
	var p_ent = P.player_entity

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
	var p = P.player
	if p == null or len(p.weapons) == 0:
		return

	var ws: Array[DinoWeaponEntity] = []
	ws.assign(p.weapons.map(func(w): return w.entity))
	weapon_list.entities = ws
	weapon_list.active_entity = p.active_weapon().entity
	weapon_list.render()

func update_time(t):
	time_label.text = "[center]%02d[/center]" % t
