@tool
extends Node

###########################################################
# enter tree

func _enter_tree():
	add_to_group(GhostsData.rooms_group, true)

###########################################################
# ready

func _ready():
	Hotel.register(self)

	if not Engine.is_editor_hint():
		Hotel.check_in(self, {ready_at=Time.get_unix_time_from_system()})

###########################################################
# hotel

func hotel_data():
	return {
		name=name,
		scene_file_path=scene_file_path,
		}

func check_out(_data):
	pass
