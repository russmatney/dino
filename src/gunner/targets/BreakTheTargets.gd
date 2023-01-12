extends Node2D

var targets = []
var player

###############################################################################
# ready

func _ready():
	print("[Gunner] BREAK THE TARGETS!")

	targets = get_tree().get_nodes_in_group("target")

	var players = get_tree().get_nodes_in_group("player")
	if players:
		player = players[0]
		player.call_deferred("notif", "BREAK THE TARGETS")

	for t in targets:
		Util.ensure_connection(t, "destroyed", self, "_on_target_destroyed")

	Util.ensure_connection(Gunner, "respawn", self, "_on_respawn")
	Util.ensure_connection(Cam, "slowmo_stopped", self, "_on_slowmo_stopped")

###############################################################################
# signals

func _on_respawn(node):
	if node.is_in_group("target"):
		Util.ensure_connection(node, "destroyed", self, "_on_target_destroyed")
		targets.append(node)
		target_change()

func _on_target_destroyed(t):
	# needs to happen before t is queue_freed
	targets.erase(t)
	target_change({"was_destroy": true})


###############################################################################
# update

func target_change(opts = {}):
	if targets.size() == 1 and opts.get("was_destroy"):
		if player:
			player.notif("ONE REMAINING")
		Cam.start_slowmo("one-target-left", 0.3)
	elif targets.empty() and opts.get("was_destroy"):
		Cam.stop_slowmo("one-target-left")
		if player:
			player.notif("TARGETS CLEARED")
		Cam.freezeframe("targets-cleared", 0.01, 3)
	else:
		Cam.stop_slowmo("one-target-left")

func _on_slowmo_stopped(label):
	if label == "targets-cleared":
		if player:
			player.level_up()
		Gunner.respawn_missing()
