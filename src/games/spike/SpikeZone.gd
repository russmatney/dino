@tool
extends MetroZone
class_name SpikeZone

## zones ##########################################################

const zone_scenes = [
	# "res://src/games/spike/zones/ZoneGym.tscn",
	"res://src/games/spike/zones/BasicLevelOne.tscn",
	"res://src/games/spike/zones/PantryOne.tscn",
	"res://src/games/spike/zones/PantryTwo.tscn",
	"res://src/games/spike/zones/FlatLandOne.tscn",
	# "res://src/games/spike/zones/FlatLandTwo.tscn",
	"res://src/games/spike/zones/FinalZoneOne.tscn",
	"res://src/games/spike/zones/FinalZoneTwo.tscn",
	]

## ready #####################################################

func _ready():
	# TODO restore via QuestManager
	# if not Engine.is_editor_hint():
		# Q.all_quests_complete.connect(on_quests_complete)

		# var quest = QuestFeedTheVoid.new()
		# add_child(quest)

		# Q.setup_quests()

	super._ready()

## quest updates ######################################################

func on_quests_complete():
	Sounds.play(Sounds.S.fire)

	Jumbotron.jumbo_notif({header="Congrats on feeding the void.", body="woo-hoo.",
		action="close", action_label_text="Next Level",
		on_close=handle_level_complete})

## level_complete ######################################################

func handle_level_complete():
	var curr_level_idx = zone_scenes.find(Navi.current_scene_path())
	var next_level_idx = curr_level_idx + 1
	if next_level_idx < zone_scenes.size():
		var next_level = zone_scenes[next_level_idx]
		Metro.load_zone(next_level)
	else:
		Navi.show_win_menu()
