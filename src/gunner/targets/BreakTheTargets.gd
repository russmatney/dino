extends Node2D

var targets = []
var player
var hud
var destroyed_count = 0

###############################################################################
# ready

func _ready():
	print("[Gunner] BREAK THE TARGETS!")
	# defer until everything has hit the scene tree
	call_deferred("setup")

func setup():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		player = players[0]
		player.call_deferred("notif", "BREAK THE TARGETS")
		Gunner.notif("Break The Targets!")

	targets = get_tree().get_nodes_in_group("target")
	for t in targets:
		Util.ensure_connection(t, "destroyed", self, "_on_target_destroyed")

	print("targets? :(", targets.size())

	find_hud()

	Util.ensure_connection(Gunner, "respawn", self, "_on_respawn")
	Util.ensure_connection(Cam, "slowmo_stopped", self, "_on_slowmo_stopped")

func find_hud():
	var huds = get_tree().get_nodes_in_group("hud")
	if huds:
		hud = huds[0]

	if hud:
		print("found hud and targets: ", targets.size())
		hud.update_targets_remaining(targets.size())
	else:
		print("no hud found :(")

var wait_for = 5
var has_warned = false

func _process(delta):
	# TODO refactor to some sensible pattern
	if wait_for > 0:
		wait_for -= delta
		if not hud:
			find_hud()
	else:
		if not hud and not has_warned:
			has_warned = true
			print("[WARN]: BreakTheTargets could not find HUD, giving up.")



###############################################################################
# signals

func _on_respawn(node):
	if node.is_in_group("target"):
		Util.ensure_connection(node, "destroyed", self, "_on_target_destroyed")
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
			player.notif("ONE REMAINING")
		Cam.freezeframe("one-target-left", 0.3, 2)
	elif targets.empty() and opts.get("was_destroy"):
		if player:
			player.notif("TARGETS CLEARED")
		Cam.freezeframe("targets-cleared", 0.01, 3)

func _on_slowmo_stopped(label):
	if label == "targets-cleared":
		if player:
			player.level_up()
		Gunner.respawn_missing()
