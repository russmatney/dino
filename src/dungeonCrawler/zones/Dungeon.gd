@tool
extends Node2D

@onready var player_start = get_node("%PlayerStart")
var player

#######################################################################33
# warnings


func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=["PlayerStart"]})


enum w_type { DEFEAT_BOSS, GET_TREASURE }
@export var win_type: w_type = w_type.DEFEAT_BOSS

#######################################################################33
# ready


func _ready():
	player = player_start.spawn_player(self)

	if player:
		player.add_to_group("player")
	else:
		Log.pr("failed to spawn player?")


var once = true

#######################################################################33
# process


func _process(_delta):
	if once and is_win():
		if once:
			once = false
		Log.pr("win!")
		Navi.show_win_menu()


#######################################################################33
# win


func is_win():
	match win_type:
		w_type.DEFEAT_BOSS:
			# probably a flimsy way to get bosses
			var bosses = get_tree().get_nodes_in_group("bosses")
			if bosses:
				for boss in bosses:
					if not boss.get("dead"):
						return false
				# win if all found bosses and they are dead
				return true

	return false
