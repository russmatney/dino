extends Node2D


func _ready():
	var _x = Hood.connect("found_player", self, "setup")
	if Hood.player:
		setup(Hood.player)

var enemy_snakes
var player
var remaining_enemies_count

func setup(p):
	player = p
	player.call_deferred("highlight", "Kill The Snakes!")
	Hood.notif("Kill the Snakes!")

	find_snakes()

	# TODO consider connecting to snake created signal


func find_snakes():
	var ss = []
	var enemies = get_tree().get_nodes_in_group("enemy")
	print("enemies: ", enemies)
	for e in enemies:
		if e.is_in_group("snakes"):
			print("found snake")
			Util.ensure_connection(e, "destroyed", self, "_on_destroyed")
			ss.append(e)

	enemy_snakes = ss


func _on_destroyed(snake):
	enemy_snakes.erase(snake)

	if not enemy_snakes:
		Hood.notif("Enemies Cleared!")
	else:
		Hood.notif(str(enemy_snakes.size(), " Enemies remaining!"))
