extends Node2D


func _ready():
	Game.player_found.connect(setup)
	if Game.player and is_instance_valid(Game.player):
		setup(Game.player)

	Quest.register_quest(self)

func _exit_tree():
	Quest.unregister(self)

signal quest_complete
# signal quest_failed
signal count_remaining_update
signal count_total_update

var enemy_snakes
var player

func setup(p):
	if not is_instance_valid(p):
		return
	player = p
	player.highlight.call_deferred("Kill The Snakes!")
	Hood.notif("Kill the Snakes!")

	find_snakes()

	# TODO consider connecting to snake created signal


func find_snakes():
	var ss = []
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if e.is_in_group("snakes"):
			Util._connect(e.destroyed, _on_destroyed)
			ss.append(e)

	enemy_snakes = ss
	count_total_update.emit(str(enemy_snakes.size()))


func _on_destroyed(snake):
	enemy_snakes.erase(snake)

	count_remaining_update.emit(enemy_snakes.size())
	if len(enemy_snakes) == 0:
		Hood.notif("Enemies Cleared!")
		quest_complete.emit()
	else:
		Hood.notif(str(enemy_snakes.size(), " Enemies remaining!"))
