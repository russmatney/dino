extends CanvasLayer

## vars ############################################################33

@onready var player_status = $%PlayerStatus
@onready var level_opts_comp = $%LevelOpts

var level_opts

## setters ############################################################33

func set_level_opts(opts: Dictionary):
	level_opts = opts

## _ready ############################################################33

func _ready():
	Log.pr("Dino HUD ready")
	P.player_ready.connect(update_player_status)
	update_player_status()
	update_level_opts()

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
