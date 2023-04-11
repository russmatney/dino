extends Node2D


func _ready():
	var _x = Hood.found_player.connect(setup)
	if Hood.player and is_instance_valid(Hood.player):
		setup(Hood.player)

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
	player = p
	player.hightlight.call_deferred("Kill The Snakes!")
	Hood.notif("Kill the Snakes!")

	find_snakes()

	# TODO consider connecting to snake created signal


func find_snakes():
	var ss = []
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if e.is_in_group("snakes"):
			Util.ensure_connection(e, "destroyed", self, "_on_destroyed")
			ss.append(e)

	enemy_snakes = ss
	count_total_update.emit(str(enemy_snakes.size()))



func _on_destroyed(snake):
	enemy_snakes.erase(snake)

	count_remaining_update.emit(enemy_snakes.size())
	if not enemy_snakes:
		Hood.notif("Enemies Cleared!")
		quest_complete.emit()
	else:
		Hood.notif(str(enemy_snakes.size(), " Enemies remaining!"))
