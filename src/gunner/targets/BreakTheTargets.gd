@tool
extends Node2D

var targets = []
var player
var hud
var destroyed_count = 0

signal targets_cleared

###############################################################################
# ready


func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		player = players[0]
		player.notif.call_deferred("BREAK THE TARGETS")
		Hood.notif("Break The Targets!")
		Debug.pr("btt found player: ", player)

	targets = get_tree().get_nodes_in_group("target")
	for t in targets:
		t.destroyed.connect(_on_target_destroyed)

	# TODO refactor this reference away - hud (and quests like this) should depend on hotel instead
	# if Hood.hud:
	# 	Hood.hud.update_targets_remaining(targets.size())
	# else:
	# 	Hood.hud_ready.connect(func (): Hood.hud.update_targets_remaining(targets.size()))

	Respawner.respawn.connect(_on_respawn)
	Cam.slowmo_stopped.connect(_on_slowmo_stopped)

###############################################################################
# signals


func _on_respawn(node):
	if node.is_in_group("target"):
		node.destroyed.connect(_on_target_destroyed)
		targets.append(node)
		target_change()
		if hud:
			hud.update_targets_remaining(targets.size())


func _on_target_destroyed(t):
	# needs to happen before t is queue_freed
	targets.erase(t)
	target_change({"was_destroy": true})

	destroyed_count += 1

	if hud:
		hud.update_targets_destroyed(destroyed_count)
		hud.update_targets_remaining(targets.size())


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
