extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysModule.gd"

func _initialize():
	Log.pr("vania room transitions inited")
	MetSys.room_changed.connect(_on_room_changed, CONNECT_DEFERRED)

var PLAYER_POS_OFFSET = 30

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


	var og_player = Dino.current_player_node()
	if (new_room_def.room_type != prev_room_def.room_type):
		Log.pr("room type change, need to update player!")

		var player_parent = og_player.get_parent()
		# TODO carry over velocity/momentum
		Dino.respawn_active_player({
			new_room_type=new_room_def.room_type, deferred=false, level_node=player_parent,
			setup=func(p):
			p.position = og_player.position
			})

	if prev_room_instance:
		var player = Dino.current_player_node()
		if not player:
			Log.warn("Room transition found no player node!")
		else:
			var offset = MetSys.get_current_room_instance().get_room_position_offset(prev_room_instance)
			Log.pr("offset", offset)

			if offset.y < 0:
				offset.y += PLAYER_POS_OFFSET
			if offset.y > 0:
				offset.y -= PLAYER_POS_OFFSET
			if offset.x < 0:
				offset.x += PLAYER_POS_OFFSET
			if offset.x > 0:
				offset.x -= PLAYER_POS_OFFSET

			Log.pr("adjusted offset", offset)
			player.position -= offset
		prev_room_instance.queue_free()
