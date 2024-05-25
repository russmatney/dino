extends RefCounted
class_name VaniaRoomTransitions

## vars ##################################

var PLAYER_POS_OFFSET = 40
var game: VaniaGame

## init ##################################

func _init(p_game: VaniaGame) -> void:
	game = p_game

	MetSys.room_changed.connect(_on_room_changed, CONNECT_DEFERRED)

## on_room_changed ##################################

func _on_room_changed(target_room: String, ignore_same_room=true):
	if ignore_same_room and target_room == MetSys.get_current_room_name():
		# This can happen when teleporting to another room.
		return

	var new_room_def = game.get_room_def(target_room)
	var prev_room_def = game.get_room_def(MetSys.get_current_room_name())

	if new_room_def == null:
		Log.warn("No new room def in room transition, aborting", target_room)
	if prev_room_def == null:
		Log.warn("No prev room def in room transition, aborting", MetSys.get_current_room_name())

	var prev_room_instance = MetSys.get_current_room_instance()
	if prev_room_instance:
		prev_room_instance.get_parent().remove_child(prev_room_instance)

	await game._load_room(target_room, {setup=func(room):
		room.set_room_def(game.get_room_def(target_room))})

	var og_player = Dino.current_player_node()
	var og_p_position = og_player.position
	var og_p_velocity = og_player.velocity

	var offset = Vector2()
	if prev_room_instance:
		offset = MetSys.get_current_room_instance().get_room_position_offset(prev_room_instance)

		# maybe some nice way to handle this
		if abs(og_p_velocity.x) > abs(og_p_velocity.y):
			if offset.x < 0:
				offset.x += PLAYER_POS_OFFSET
			if offset.x > 0:
				offset.x -= PLAYER_POS_OFFSET
		else:
			if offset.y < 0:
				offset.y += PLAYER_POS_OFFSET
			if offset.y > 0:
				offset.y -= PLAYER_POS_OFFSET

	if (new_room_def.genre_type() != prev_room_def.genre_type()):
		var player_parent = og_player.get_parent()
		# TODO carry over velocity/momentum, other stats? (health,items,etc)
		# playerData or playerDef class with data? (like room vs roomDef?)
		Dino.respawn_active_player({
			genre_type=new_room_def.genre_type(),
			# deferred=false,
			level_node=player_parent, # this is the default behavior
			setup=func(p): p.position = og_p_position - offset
			})
	else:
		og_player.position -= offset
