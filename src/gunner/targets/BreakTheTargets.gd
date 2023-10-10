@tool
extends Node2D

var targets = []
var player
var destroyed_count = 0

signal targets_cleared

###############################################################################
# ready

func _ready():
	Hotel.register(self)
	Game.player_found.connect(notify_player)

	targets = get_tree().get_nodes_in_group("target")
	for t in targets:
		t.destroyed.connect(_on_target_destroyed)

	Respawner.respawn.connect(_on_respawn)
	Cam.slowmo_stopped.connect(_on_slowmo_stopped)

func check_out(data):
	destroyed_count = data.get("destroyed_count", destroyed_count)

func hotel_data():
	return {destroyed_count=destroyed_count, remaining_count=len(targets)}

###############################################################################
# signals

func notify_player(p):
	player = p
	player.notif.call_deferred("BREAK THE TARGETS")
	Hood.notif("Break The Targets!")


func _on_respawn(node):
	if node.is_in_group("target"):
		node.destroyed.connect(_on_target_destroyed)
		targets.append(node)
		target_change()


func _on_target_destroyed(t):
	# needs to happen before t is queue_freed
	targets.erase(t)
	target_change({"was_destroy": true})

	destroyed_count += 1
	Hotel.check_in(self)


###############################################################################
# update


func target_change(opts = {}):
	if targets.size() == 1 and opts.get("was_destroy"):
		if player:
			player.notif("ONE TARGET REMAINING")
		Cam.freezeframe("one-target-left", 0.3, 0.5)
	elif targets.is_empty() and opts.get("was_destroy"):
		if player:
			player.notif("TARGETS CLEARED")
		Cam.freezeframe("targets-cleared", 0.01, 3)


func _on_slowmo_stopped(label):
	if label == "targets-cleared":
		if player:
			player.level_up()

		await get_tree().create_timer(2.0).timeout
		targets_cleared.emit()
