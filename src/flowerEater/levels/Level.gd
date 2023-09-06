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

## state/grid ##############################################################

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
			r.append(objs)
			if objs != null and "PlayerA" in objs:
				player_a_pos = Vector2(x, y)
				player_node = cell_nodes[str(x, y)].filter(func(c): return c.display_name == "PlayerA").front()
		grid.append(r)

	state = {
		grid=grid, player_a_position=player_a_pos,
		grid_xs=len(grid[0]), grid_ys=len(grid),
		stuck=false, move_history=[],
		}

# returns true if the passed coord is in the level's grid
func pos_in_grid(pos):
	return pos.x >= 0 and pos.y >= 0 and \
		pos.x < state.grid_xs and pos.y < state.grid_ys

func cell_at_coord(coord):
	var cell = state.grid[coord.y][coord.x]
	var nodes = cell_nodes.get(str(coord.x, coord.y))
	return {objs=cell, coord=coord, nodes=nodes}

# returns a list of cells from the passed position in the passed direction
# the cells are dicts with a coord, a list of objs (string names), and a list of nodes
func cells_in_dir(pos, dir):
	var cells = []
	var cursor = pos + dir
	while pos_in_grid(cursor):
		cells.append(cell_at_coord(cursor))
		cursor += dir
	return cells

# Returns a list of cell object names
func all_cells():
	var cs = []
	for row in state.grid:
		for cell in row:
			cs.append(cell)
	return cs

# Returns true if there are no "Flower" objects in the state grid
func all_flowers_eaten():
	return all_cells().map(func(c):
		if c == null:
			return true
		for obj_name in c:
			if obj_name == "Flower":
				return false
		return true).all(func(x): return x)

## move/state-updates ##############################################################

# Move the player to the passed cell's coordinate.
# also updates the game state
# cell should have a `coord`
# this depends on the level's `player_node` var
# TODO history for two players
func move_player_to_cell(cell):
	# move player node
	# TODO animate/tween/sound/fun
	# probably a func to call on player node w/ the new position
	player_node.position = cell.coord * square_size

	# update game state
	state.grid[cell.coord.y][cell.coord.x].append("PlayerA")
	state.grid[state.player_a_position.y][state.player_a_position.x].erase("PlayerA")

	# remove previous undo marker
	var prev_undo_coord = Util.first(state.move_history)
	if prev_undo_coord != null:
		state.grid[prev_undo_coord.y][prev_undo_coord.x].erase("PlayerAUndo")

	# add new undo marker
	state.grid[state.player_a_position.y][state.player_a_position.x].append("PlayerAUndo")

	# update undo history
	state.move_history.push_front(state.player_a_position)

	# set new player state position
	state.player_a_position = cell.coord

# converts the flower at the cell's coord to an eaten one
# depends on cell for `coord` and `nodes`.
func eat_flower_at_cell(cell):
	var flower_node = cell.nodes.filter(func(c): return c.display_name == "Flower").front()

	# update cell_nodes
	cell_nodes[str(cell.coord.x, cell.coord.y)].erase(flower_node)

	# animate flower -> flower-eaten
	# TODO probably should be the same node, not a drop + add
	flower_node.queue_free()
	add_obj_to_coord("FlowerEaten", cell.coord.x, cell.coord.y)

	# update game state
	state.grid[cell.coord.y][cell.coord.x].erase("Flower")
	state.grid[cell.coord.y][cell.coord.x].append("FlowerEaten")

# converts an eatenFlower back into an uneaten one (undo!)
# depends on cell for `coord` and `nodes`.
func uneat_flower_at_cell(cell):
	var eaten_flower_node = cell.nodes.filter(func(c): return c.display_name == "FlowerEaten").front()
	if eaten_flower_node == null:
		# undoing from target doesn't require any uneating
		return

	# update cell_nodes
	cell_nodes[str(cell.coord.x, cell.coord.y)].erase(eaten_flower_node)

	# animate flower-eaten -> flower
	# TODO probably should be the same node, not a drop + add
	eaten_flower_node.queue_free()
	add_obj_to_coord("Flower", cell.coord.x, cell.coord.y)

	# update game state
	state.grid[cell.coord.y][cell.coord.x].erase("FlowerEaten")
	state.grid[cell.coord.y][cell.coord.x].append("Flower")

## move to flower ##############################################################

func move_to_flower(cell):
	# consider handling these in the same step (depending on the animation)
	move_player_to_cell(cell)
	eat_flower_at_cell(cell)

## move to target ##############################################################

func move_to_target(cell):
	move_player_to_cell(cell)
	if all_flowers_eaten():
		Debug.pr("win!")
	else:
		Debug.pr("stuck.")
		state.stuck = true

## undo last move ##############################################################

func undo_last_move(cell):
	# move player node
	# TODO animate/tween/sound/fun
	# TODO note this should be an undo animation
	# probably a func to call on player node w/ the new position
	player_node.position = cell.coord * square_size

	# update game state
	state.grid[cell.coord.y][cell.coord.x].append("PlayerA")
	state.grid[state.player_a_position.y][state.player_a_position.x].erase("PlayerA")

	if "FlowerEaten" in state.grid[state.player_a_position.y][state.player_a_position.x]:
		# uneat the flower in the current player position
		uneat_flower_at_cell(cell_at_coord(state.player_a_position))
	if "Target" in state.grid[state.player_a_position.y][state.player_a_position.x]:
		# unstuck when undoing from the target
		state.stuck = false

	# remove last move from move_history
	state.move_history.pop_front()

	var new_undo_coord = Util.first(state.move_history)
	if new_undo_coord != null:
		state.grid[new_undo_coord.y][new_undo_coord.x].append("PlayerAUndo")
	state.grid[cell.coord.y][cell.coord.x].erase("PlayerAUndo")

	# update state player position
	state.player_a_position = cell.coord

## move ##############################################################

func move(move_dir):
	# TODO for each player...
	var cells = cells_in_dir(state.player_a_position, move_dir)
	if len(cells) == 0:
		# TODO express/animate stuck/edge move
		return

	for cell in cells:
		if cell.objs == null:
			continue
		if "PlayerAUndo" in cell.objs:
			Debug.pr("Undo!")
			undo_last_move(cell)
			break
		if "Flower" in cell.objs and not state.stuck:
			Debug.pr("flower! eat it", cell)
			move_to_flower(cell)
			break
		if "Target" in cell.objs and not state.stuck:
			Debug.pr("target! complete?", cell)
			move_to_target(cell)
			break
		# TODO prevent backwards movement
		# TODO handle UNDO (flower un-eaten)
		# TODO handle no cells in direction
		Debug.warn("unexpeced/unhandled cell in direction", cell, "stuck?", state.stuck)
