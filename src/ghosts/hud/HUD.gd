extends CanvasLayer

var player

func _ready():
	print("ghosts player hud ready")

	# TODO connect to player spawn signals instead
	call_deferred("find_player")

###################################################################
# find player

export (String) var player_group = "player"

func find_player():
	var ps = get_tree().get_nodes_in_group(player_group)
	if ps.size() > 1:
		print("[WARN] HUD found multiple in player_group: ", player_group)

	if ps:
		player = ps[0]
		print("[HUD] found player: ", player)
	else:
		print("[WARN] HUD found zero in player_group: ", player_group)
		return

	if player:
		player.connect("health_change", self, "update_player_health")


###################################################################
# update health

func update_player_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)
