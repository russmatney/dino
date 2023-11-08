extends Node2D

## vars ###################################################

@onready var level_gen = $LevelGen

signal level_complete

## ready ###################################################

func _ready():
	Game.maybe_spawn_player()

	level_gen.new_data_generated.connect(setup)

	setup()

## setup ###################################################

func setup(_data=null):
	connect_to_end_room()

func connect_to_end_room():
	# TODO should fire when rooms are added
	var rooms = $Rooms.get_children()
	var end_room = rooms[len(rooms) - 1]
	for ch in end_room.get_children():
		if ch.is_in_group("roombox"):
			ch.body_entered.connect(_on_end_room_entered)

## end room entered ###################################################

func _on_end_room_entered(body: Node2D):
	if body.is_in_group("player"):
		level_complete.emit()

	# 	Debug.pr("level complete")

	# 	await get_tree().create_timer(0.3).timeout
	# 	# clean up nodes/player
	# 	Game.player.queue_free()

	# 	# pick new seed
	# 	level_gen._seed = randi()
	# 	Debug.pr("new seed: ", level_gen._seed)

	# 	await get_tree().create_timer(0.3).timeout
	# 	# regen level
	# 	level_gen.generate()

	# 	await get_tree().create_timer(0.4).timeout
	# 	# respawn player
	# 	Game.maybe_spawn_player.call_deferred()
