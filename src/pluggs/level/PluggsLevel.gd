extends Node2D

## vars ###################################################

@onready var level_gen = $LevelGen

## ready ###################################################

func _ready():
	Game.maybe_spawn_player()
	level_gen.new_data_generated.connect(setup)
	setup()

## setup ###################################################

func setup(_opts=null):
	connect_to_rooms()

func connect_to_rooms():
	if Engine.is_editor_hint():
		return
	for ent in $Entities.get_children():
		if ent.is_in_group("arcade_machine"):
			Util._connect(ent.plugged, on_arcade_machine_plugged)

## on plugged ###################################################

func on_arcade_machine_plugged():
	Debug.pr("arcade machine plugged!")

	Hood.notif("Rebooting world....")
	await get_tree().create_timer(0.3).timeout
	level_gen._seed = randi() # may want this to happen at a global level at some point
	Hood.notif("New seed....", level_gen._seed)
	level_gen.generate()
	await get_tree().create_timer(0.3).timeout
	Game.respawn_player()