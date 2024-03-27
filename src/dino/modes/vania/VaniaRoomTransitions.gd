extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysModule.gd"

func _initialize():
	Log.pr("vania room transitions inited")
	MetSys.room_changed.connect(_on_room_changed, CONNECT_DEFERRED)

func _on_room_changed(target_room: String):
	if target_room == MetSys.get_current_room_name():
		# This can happen when teleporting to another room.
		return

	Log.pr("on room changed", target_room, MetSys.get_current_room_name())
	var new_room_def = game.get_room_def(target_room)
	var prev_room_def = game.get_room_def(MetSys.get_current_room_name())
	Log.pr("new room def", new_room_def)
	Log.pr("prev room def", prev_room_def)

	var prev_room_instance := MetSys.get_current_room_instance()
	if prev_room_instance:
		prev_room_instance.get_parent().remove_child(prev_room_instance)

	await game.load_room(target_room)

	if prev_room_instance:
		var player = Dino.current_player_node()
		if not player:
			Log.warn("Room transition found no player node!")
		else:
			player.position -= MetSys.get_current_room_instance().get_room_position_offset(prev_room_instance)
		prev_room_instance.queue_free()
