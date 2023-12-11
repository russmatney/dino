extends CanvasLayer

## vars ############################################################33

@onready var player_status = $%PlayerStatus


## _ready ############################################################33

func _ready():
	Log.pr("Dino HUD ready")
	P.player_ready.connect(update_player_status)
	update_player_status()

func update_player_status():
	var p_ent = P.player_entity

	if p_ent != null:
		player_status.set_status({"entity": p_ent})
