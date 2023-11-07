@tool
extends NaviButtonList

var themes

func _ready():
	var ent = Pandora.get_entity(DhTheme.DEBUG)
	themes = Pandora.get_all_entities(Pandora.get_category(ent._category_id))

	# TODO restore dothop theme-switching without singletons
	# for th in themes:
	# 	add_menu_item({
	# 		label=th.get_display_name(),
	# 		fn=func():
	# 			var dh = Engine.get_singleton("DotHop")
	# 			dh.change_theme(th),
	# 		})
