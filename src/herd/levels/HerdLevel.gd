extends Node2D
class_name HerdLevel

## level menu #####################################################

var next_level_menu

## ready #####################################################

func _ready():
	var next_level_menu_scene = load("res://src/herd/menus/NextLevelMenu.tscn")
	next_level_menu = Navi.add_menu(next_level_menu_scene)

	level_complete = false

	if Game.player and is_instance_valid(Game.player):
		Hotel.check_in(Game.player, {health=Game.player.max_health})

	Quest.all_quests_complete.connect(on_quests_complete)
	Quest.quest_failed.connect(on_quest_failed)

	Game.maybe_spawn_player()


## quest updates #####################################################

var level_complete

func on_quests_complete():
	DJZ.play(DJZ.S.fire)
	level_complete = true
	handle_level_complete()

func on_quest_failed(_quest):
	DJZ.play(DJZ.S.heavy_fall)
	level_complete = true
	Quest.jumbo_notif({header="All the sheep died.", body="Yeesh!",
		action="close", action_label_text="Restart Level",
		on_close=retry_level})

func retry_level():
	var level_idx = HerdData.levels.find(Navi.current_scene_path())
	if len(HerdData.levels) <= level_idx:
		Debug.err("level_idx too high, can't retry level")
		return
	Navi.nav_to(HerdData.levels[level_idx])

## level_complete #####################################################

func handle_level_complete():
	var level_idx = HerdData.levels.find(Navi.current_scene_path())
	if level_idx == len(HerdData.levels) - 1:
		next_level_menu.update_hero_text("You Win!")
	else:
		next_level_menu.update_hero_text("Level Complete!")
	next_level_menu.update_sheep_saved()
	next_level_menu.update_buttons()
	Navi.show_menu(next_level_menu)
