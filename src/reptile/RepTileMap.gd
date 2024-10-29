@tool
extends TileMap
class_name RepTileMap


@export var recalc_autotiles: bool :
	set(v):
		if v and Engine.is_editor_hint():
			var cells = get_used_cells(0)
			set_cells_terrain_connect(0, cells, 0, 0)

func destroy_tile_with_rid(rid):
	var coords = get_coords_for_body_rid(rid)
	if coords:
		var tile_data = get_cell_tile_data(0, coords)
		if tile_data:
			var mat = tile_data.material
			if mat is ShaderMaterial:
				mat.set_shader_parameter("offset", mat.get_shader_parameter("fade"))
			else:
				erase_cell(0, coords)
		else:
			erase_cell(0, coords)
		return true
	return false
