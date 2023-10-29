@tool
extends BrickRoom
class_name PluggsRoom

##########################################################################
## static ##################################################################

## create room ##################################################################

static func create_room(opts):
	var room = PluggsRoom.new()

	opts["tilemap_scene"] = load("res://addons/reptile/tilemaps/MetalTiles8.tscn")

	opts["label_to_entity"] = {
		"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
		"Machine": {scene=load("res://src/pluggs/entities/ArcadeMachine.tscn")},
		"Light": {scene=load("res://src/pluggs/entities/Light.tscn")},
		}

	room.gen(opts)
	return room

##########################################################################
## instance ##################################################################

## vars

signal machine_plugged

## ready #############################################################

func _ready():
	if Engine.is_editor_hint():
		return

	for e in get_children():
		if e.is_in_group("arcade_machine"):
			e.plugged.connect(on_machine_plugged)
			Debug.pr("connected room to arcade machine plugged signal")

## plugged #############################################################

func on_machine_plugged():
	machine_plugged.emit()
