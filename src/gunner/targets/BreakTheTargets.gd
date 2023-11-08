@tool
extends Node2D

var targets = []
var player
var destroyed_count = 0

signal targets_cleared

###############################################################################
# ready

func _ready():
	setup()

func setup():
	Hotel.register(self)

	targets = []
	for t in get_tree().get_nodes_in_group("target"):
		if not is_instance_valid(t):
			continue
		targets.append(t)
		if not Engine.is_editor_hint():
			Util._connect(t.destroyed, _on_target_destroyed)
			Util._connect(t.tree_exiting, _on_target_exiting.bind(t))

	if not Engine.is_editor_hint():
		Respawner.respawn.connect(_on_respawn)
		Cam.slowmo_stopped.connect(_on_slowmo_stopped)

	target_change()

func check_out(data):
	destroyed_count = data.get("destroyed_count", destroyed_count)

func hotel_data():
	return {destroyed_count=destroyed_count, remaining_count=len(targets)}

###############################################################################
# signals

func _on_respawn(_node):
	setup()

func _on_target_destroyed(t):
	Debug.pr("on target destroyed", t, destroyed_count)
	# needs to happen before t is queue_freed
	targets.erase(t)
	target_change({"was_destroy": true})

	destroyed_count += 1
	Hotel.check_in(self)

func _on_target_exiting(t):
	targets.erase(t)

###############################################################################
# update


func target_change(opts = {}):
	Debug.pr("targets remaining", targets.size(), targets)
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
