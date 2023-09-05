@tool
extends Node2D

var game_def
var level_def :
	set(ld):
		level_def = ld
		setup_level()
		init_game_state()
var square_size = 64
var cell_nodes = {}
var state

var obj_scene = {
	"fallback": preload("res://src/flowerEater/objects/GenericObj.tscn"),
	"PlayerA": preload("res://src/flowerEater/objects/PlayerA.tscn"),
	"PlayerB": preload("res://src/flowerEater/objects/PlayerB.tscn"),
	"Flower": preload("res://src/flowerEater/objects/Flower.tscn"),
	"FlowerEaten": preload("res://src/flowerEater/objects/FlowerEaten.tscn"),
	"Target": preload("res://src/flowerEater/objects/Target.tscn"),
	}

## ready ##############################################################

func _ready():
	if level_def == null:
		Debug.pr("level ready!", name)
	else:
		Debug.pr("level ready!", name, level_def.get("message"))
		setup_level()
		init_game_state()

## setup level ##############################################################

func setup_level():
	if level_def == null:
		return

	cell_nodes = {}

	for ch in get_children():
		ch.free()

	for y in range(len(level_def.shape)):
		for x in range(len(level_def.shape[y])):
			var cell = level_def.shape[y][x]
			add_square(x, y, cell)

func add_square(x, y, cell):
	if cell == null:
		var pos = Vector2(x, y) * square_size
		var size = Vector2.ONE * square_size
		Util.add_color_rect(self, pos, size, Color.PERU)
		return

	var objs = Puzz.get_cell_objects(game_def, cell)

	for obj_name in objs:
		add_obj_to_coord(obj_name, x, y)

func add_obj_to_coord(obj_name, x, y):
	var pos = Vector2(x, y) * square_size
	var scene = Util.get_(obj_scene, obj_name, obj_scene["fallback"])
	var obj = scene.instantiate()
	obj.position = pos
	add_child(obj)
	obj.set_owner(self)

	obj.display_name = obj_name
	obj.square_size = square_size

	var coord_id = str(x,y)
	if not coord_id in cell_nodes:
		cell_nodes[coord_id] = []
	cell_nodes[coord_id].append(obj)

	return obj

## input ##############################################################

func _unhandled_input(event):
	if Trolley.is_move(event):
		move(Trolley.move_vector())

## game ##############################################################

var player_node

func init_game_state():
	var grid = []
	var player_a_pos
	for y in len(level_def.shape):
		var row = level_def.shape[y]
		var r = []
		for x in len(row):
			var cell = level_def.shape[y][x]
			var objs = Puzz.get_cell_objects(game_def, cell)
			if objs != null:
				objs = objs.duplicate()
			r.append(objs)
			if objs != null and "PlayerA" in objs:
				player_a_pos = Vector2(x, y)
				player_node = Util.first(cell_nodes[str(x, y)].filter(func(c): return c.display_name == "PlayerA"))
		grid.append(r)

	state = {
		grid=grid, player_a_position=player_a_pos,
		grid_xs=len(grid[0]),
		grid_ys=len(grid),
		}

func pos_in_grid(pos):
	return pos.x >= 0 and pos.y >= 0 and \
		pos.x < state.grid_xs and pos.y < state.grid_ys

func move(move_dir):
	Debug.prn(move_dir, state.grid[1])
	# TODO for each player...
	var curr = state.player_a_position
	var cells = cells_in_dir(curr, move_dir)
	var dest_cell
	var dest_coord
	for cell in cells:
		if cell.objs == null:
			continue
		if "Flower" in cell.objs:
			Debug.pr("flower! eat it", cell)
			dest_cell = cell
			dest_coord = cell.coord
			break
		if "Target" in cell.objs:
			Debug.pr("target! complete?", cell)
			dest_cell = cell
			dest_coord = cell.coord
			break
		Debug.pr("unhandled cell in direction")
	if dest_coord == null:
		Debug.pr("no valid landing coord, no-op!")
		# TODO animate, sound, etc
		return

	var dest_nodes = cell_nodes.get(str(dest_coord.x, dest_coord.y))

	Debug.pr("cell, nodes at dest", dest_coord, dest_cell, dest_nodes)

	# flower eaten
	var flower_node = Util.first(dest_nodes.filter(func(c): return c.display_name == "Flower"))
	if flower_node:
		cell_nodes[str(dest_coord.x, dest_coord.y)].erase(flower_node)
		# TODO animate/kill/some api?
		flower_node.queue_free()
		add_obj_to_coord("FlowerEaten", dest_coord.x, dest_coord.y)
		Debug.pr("erasing flower from state", state.grid[dest_coord.y])
		state.grid[dest_coord.y][dest_coord.x].erase("Flower")
		state.grid[dest_coord.y][dest_coord.x].append("FlowerEaten")
		Debug.pr("erased flower from state", state.grid[dest_coord.y])

	# TODO flower un-eaten

	# move player
	# TODO animate, etc
	player_node.position = dest_coord * square_size
	Debug.pr("moving player in state", state.grid[dest_coord.y])
	state.grid[dest_coord.y][dest_coord.x].append("PlayerA")
	state.grid[curr.y][curr.x].erase("PlayerA")
	Debug.pr("moved player in state", state.grid[curr.y])
	state.player_a_position = dest_coord

	# check for win/stuck
	pass

func cells_in_dir(pos, dir):
	var cells = []
	var cursor = pos + dir
	while pos_in_grid(cursor):
		var cell = state.grid[cursor.y][cursor.x]
		cells.append({objs=cell, coord=cursor})
		cursor += dir
	return cells
