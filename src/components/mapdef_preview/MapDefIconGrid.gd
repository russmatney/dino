extends GridContainer

## vars #########################################

@export var map_def: MapDef :
	set(v):
		if v:
			map_def = v
			render()

## ready #########################################

func _ready():
	render()

## render #########################################

func render():
	if not is_node_ready() or not map_def:
		return

	U.remove_children(self)

	var enemies = map_def.all_enemies({distinct=true})
	var entities = map_def.all_entities({distinct=true})
	var ents = []
	ents.append_array(entities)
	ents.append_array(enemies)

	for en in ents:
		var icon = en.get_icon_texture()
		if not icon:
			continue
		var texture_rect = TextureRect.new()
		texture_rect.set_texture(icon)
		texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		texture_rect.set_custom_minimum_size(128*Vector2.ONE)
		add_child(texture_rect)
