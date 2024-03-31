extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysModule.gd"

func _initialize():
	MetSys.room_changed.connect(_on_room_changed, CONNECT_DEFERRED)

var PLAYER_POS_OFFSET = 30

func _on_room_changed(target_room: String):
	if target_room == MetSys.get_current_room_name():
		# This can happen when teleporting to another room.
		return

	var new_room_def = game.get_room_def(target_room)
	var prev_room_def = game.get_room_def(MetSys.get_current_room_name())

	var prev_room_instance := MetSys.get_current_room_instance()
	if prev_room_instance:
		prev_room_instance.get_parent().remove_child(prev_room_instance)

	await game.load_room(target_room, {setup=func(room):
		room.set_room_def(game.get_room_def(target_room))})

	var og_player = Dino.current_player_node()
	if (new_room_def.room_type != prev_room_def.room_type):
		var player_parent = og_player.get_parent()
		# TODO carry over velocity/momentum, plus probably other stats (health,items,etc)
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

			# maybe some nice way to handle this
			if abs(og_player.velocity.x) > abs(og_player.velocity.y):
				if offset.x < 0:
					offset.x += PLAYER_POS_OFFSET
				if offset.x > 0:
					offset.x -= PLAYER_POS_OFFSET
			else:
				if offset.y < 0:
					offset.y += PLAYER_POS_OFFSET
				if offset.y > 0:
					offset.y -= PLAYER_POS_OFFSET

			player.position -= offset
		prev_room_instance.queue_free()
