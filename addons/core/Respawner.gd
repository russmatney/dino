@tool
extends Node

# func _unhandled_input(event):
# 	# TODO probably don't want this checked _all_ the time
# 	if Trolley.is_event(event, "respawns"):
# 		Hood.notif("Respawning Targets")
# 		respawn_missing()

###########################################################################
# respawns

var respawns = []
signal respawn(node)


func register_respawn(node):
	if node.filename:
		respawns.append(
			{"filename": node.filename, "position": node.get_global_position(), "node": node}
		)


func reset_respawns():
	respawns = []


func respawn_all():
	for r in respawns:
		var ins = load(r["filename"]).instantiate()
		# ins.position = r["position"]
		Navi.current_scene.call_deferred("add_child", ins)


func respawn_missing():
	var to_remove = []
	for r in respawns:
		if not is_instance_valid(r["node"]):
			to_remove.append(r)
			var ins = load(r["filename"]).instantiate()
			ins.position = r["position"]
			Navi.current_scene.call_deferred("add_child", ins)
			emit_signal("respawn", ins)

	respawns = Util.remove_matching(respawns, to_remove)
