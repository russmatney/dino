@tool
extends NaviButtonList

var themes

func _ready():
	var ent = Pandora.get_entity(DhTheme.DEBUG)
	themes = Pandora.get_all_entities(Pandora.get_category(ent._category_id))

	for th in themes:
		add_menu_item({
			label=th.get_display_name(),
			fn=func(): # TODO build an event bus so we don't need refs like this
				var dh = Engine.get_singleton("DotHop")
				dh.change_theme(th),
			})
