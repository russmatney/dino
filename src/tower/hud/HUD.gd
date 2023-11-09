extends CanvasLayer


func _ready():
	Game.player_found.connect(setup_player)
	Hood.find_player.call_deferred()


###################################################################
# player setup

var player

func setup_player(p):
	player = p

	player.health_change.connect(update_player_health)
	update_player_health(player.health)
	player.pickups_changed.connect(update_player_pickups)
	update_player_pickups(player.pickups)


###################################################################
# update health


func update_player_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)


###################################################################
# update pickups


func update_player_pickups(pickups):
	var p = get_node("%PickupsContainer")
	p.update_pickups(pickups)


