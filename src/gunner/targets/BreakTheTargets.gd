extends Node2D

## vars ##############################################################################

var targets = []
var player
var destroyed_count = 0

signal targets_cleared

## ready ##############################################################################

func _ready():
	setup()

func setup():
	Hotel.register(self)

	targets = []
	if not is_inside_tree():
		return
	for t in get_tree().get_nodes_in_group("target"):
		if not is_instance_valid(t):
			continue
		targets.append(t)
		if not Engine.is_editor_hint():
			Util._connect(t.destroyed, _on_target_destroyed)
			Util._connect(t.tree_exiting, _on_target_exiting.bind(t))

	target_change()

func check_out(data):
	destroyed_count = data.get("destroyed_count", destroyed_count)

func hotel_data():
	return {destroyed_count=destroyed_count, remaining_count=len(targets)}

## signals ##############################################################################

func _on_target_destroyed(t):
	# needs to happen before t is queue_freed
	targets.erase(t)
	target_change({"was_destroy": true})

	destroyed_count += 1
	Hotel.check_in(self)

func _on_target_exiting(t):
	targets.erase(t)

## update ##############################################################################

func target_change(opts = {}):
	if targets.size() == 1 and opts.get("was_destroy"):
		if player:
			player.notif("ONE TARGET REMAINING")
		Cam.freezeframe("one-target-left", 0.3, 0.3)
	elif targets.is_empty() and opts.get("was_destroy"):
		if player:
			player.notif("TARGETS CLEARED")
		Cam.freezeframe("targets-cleared", 0.1, 0.3)
		targets_cleared.emit()
