extends Node2D

var targets = []

###############################################################################
# ready

func _ready():
	print("[Gunner] BREAK THE TARGETS")

	targets = get_tree().get_nodes_in_group("target")

	print("found targets: ", targets.size())

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
	print("targets remaining: ", targets.size())

	if targets.size() == 1 and opts.get("was_destroy"):
		print("ONE REMAINING")
		Cam.start_slowmo("one-target-left", 0.3)
	elif targets.empty() and opts.get("was_destroy"):
		Cam.stop_slowmo("one-target-left")

		print("COMPLETE")
		Cam.freezeframe("targets-cleared", 0.01, 3)
	else:
		Cam.stop_slowmo("one-target-left")

func _on_slowmo_stopped(label):
	if label == "targets-cleared":
		Gunner.respawn_missing()
