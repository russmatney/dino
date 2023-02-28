@tool
extends TileMap


@export var recalc_autotiles: bool :
	set(v):
		if v and Engine.is_editor_hint():
			Debug.prn("recalc autotiles")
			var cells = get_used_cells(0)
			set_cells_terrain_connect(0, cells, 0, 0)
