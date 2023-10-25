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


###################################################################
# update targets

@onready var destroyed_label = get_node("%TargetsDestroyed")
@onready var remaining_label = get_node("%TargetsRemaining")


func update_targets_destroyed(count):
	destroyed_label.text = "Targets Destroyed: " + str(count)


func update_targets_remaining(count):
	remaining_label.text = "Targets Remaining: " + str(count)


###################################################################
# update enemies

@onready var e_destroyed_label = get_node("%EnemiesDestroyed")
@onready var e_remaining_label = get_node("%EnemiesRemaining")


func update_enemies_destroyed(count):
	e_destroyed_label.text = "Enemies Destroyed: " + str(count)


func update_enemies_remaining(count):
	e_remaining_label.text = "Enemies Remaining: " + str(count)
