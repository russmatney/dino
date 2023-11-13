@tool
extends NaviButtonList

var themes

func _ready():
	var ent = Pandora.get_entity(DhTheme.DEBUG)
	themes = Pandora.get_all_entities(Pandora.get_category(ent._category_id))

	for th in themes:
		add_menu_item({
			label=th.get_display_name(),
			fn=func():
			var game = get_tree().current_scene
			Log.pr("current_scene (game)", game)
			if game.name == "DotHopGame":
				game.change_theme(th)
			else:
				Log.warn("Current scene is not DotHopGame, cannot change theme", game)
			})
