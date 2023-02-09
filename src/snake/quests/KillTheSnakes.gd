extends Node2D


func _ready():
	var _x = Hood.connect("found_player",Callable(self,"setup"))
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
	player.call_deferred("highlight", "Kill The Snakes!")
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
	emit_signal("count_total_update", str(enemy_snakes.size()))



func _on_destroyed(snake):
	enemy_snakes.erase(snake)

	emit_signal("count_remaining_update", enemy_snakes.size())
	if not enemy_snakes:
		Hood.notif("Enemies Cleared!")
		emit_signal("quest_complete")
	else:
		Hood.notif(str(enemy_snakes.size(), " Enemies remaining!"))
