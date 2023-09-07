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

signal win

var obj_scene = {
	"fallback": preload("res://src/flowerEater/objects/GenericObj.tscn"),
	"Player": preload("res://src/flowerEater/objects/PlayerA.tscn"),
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

func get_cell_objs(cell):
	var objs = Puzz.get_cell_objects(game_def, cell)
	if objs != null and len(objs) > 0:
		objs = objs.map(func(n):
			if n in ["PlayerA", "PlayerB"]:
				return "Player"
			else:
				return n)
	return objs

func add_square(x, y, cell):
	if cell == null:
		var pos = Vector2(x, y) * square_size
		var size = Vector2.ONE * square_size
		Util.add_color_rect(self, pos, size, Color.PERU)
		return

	for obj_name in get_cell_objs(cell):
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

	# TODO update input maps to support these
	# if Trolley.is_restart(event):
	# 	setup_level()
	# if Trolley.is_undo(event):
	# 	for p in state.players:
	# 		undo_last_move(p)

## state/grid ##############################################################

func init_game_state():
	var grid = []
	var players = []
	for y in len(level_def.shape):
		var row = level_def.shape[y]
		var r = []
		for x in len(row):
			var cell = level_def.shape[y][x]
			var objs = get_cell_objs(cell)
			r.append(objs)
			if objs != null and "Player" in objs:
				players.append({
					coord=Vector2(x,y),
					node=cell_nodes[str(x, y)].filter(func(c): return c.display_name in ["Player", "PlayerA", "PlayerB"]).front(),
					stuck=false,
					move_history=[],
					})
		grid.append(r)

	state = {players=players, grid=grid, grid_xs=len(grid[0]), grid_ys=len(grid), win=false}

# returns true if the passed coord is in the level's grid
func coord_in_grid(coord:Vector2) -> bool:
	return coord.x >= 0 and coord.y >= 0 and \
		coord.x < state.grid_xs and coord.y < state.grid_ys

func cell_at_coord(coord:Vector2) -> Dictionary:
	var cell = state.grid[coord.y][coord.x]
	var nodes = cell_nodes.get(str(coord.x, coord.y))
	return {objs=cell, coord=coord, nodes=nodes}

# returns a list of cells from the passed position in the passed direction
# the cells are dicts with a coord, a list of objs (string names), and a list of nodes
func cells_in_dir(coord:Vector2, dir:Vector2) -> Array:
	var cells = []
	var cursor = coord + dir
	while coord_in_grid(cursor):
		cells.append(cell_at_coord(cursor))
		cursor += dir
	return cells

# Returns a list of cell object names
func all_cells() -> Array[Variant]:
	var cs = []
	for row in state.grid:
		for cell in row:
			cs.append(cell)
	return cs

# Returns true if there are no "Flower" objects in the state grid
func all_flowers_eaten() -> bool:
	return all_cells().all(func(c):
		if c == null:
			return true
		for obj_name in c:
			if obj_name == "Flower":
				return false
		return true)

func all_players_on_target() -> bool:
	return all_cells().filter(func(c):
		if c != null and "Target" in c:
			return true
		).all(func(c): return "Player" in c)

## move/state-updates ##############################################################

# Move the player to the passed cell's coordinate.
# also updates the game state
# cell should have a `coord`
# NOTE updating move_history is done after all players move
func move_player_to_cell(player, cell):
	# move player node
	# TODO animate/tween/sound/fun
	# probably a func to call on player node w/ the new position
	player.node.position = cell.coord * square_size

	# update game state
	state.grid[cell.coord.y][cell.coord.x].append("Player")
	state.grid[player.coord.y][player.coord.x].erase("Player")

	# remove previous undo marker - NOTE history has already been updated
	if len(player.move_history) > 1:
		var prev_undo_coord = player.move_history[1]
		state.grid[prev_undo_coord.y][prev_undo_coord.x].erase("Undo")
		# Debug.pr("undo erased", state.grid[prev_undo_coord.y])

	# add new undo marker at current coord
	state.grid[player.coord.y][player.coord.x].append("Undo")
	# Debug.pr("undo appended", state.grid[player.coord.y])

	# update to new coord
	player.coord = cell.coord

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

func move_to_flower(player, cell):
	# consider handling these in the same step (depending on the animation)
	move_player_to_cell(player, cell)
	eat_flower_at_cell(cell)

## move to target ##############################################################

func move_to_target(player, cell):
	move_player_to_cell(player, cell)
	if all_flowers_eaten() and all_players_on_target():
		Debug.pr("win!")
		state.win = true
		win.emit()
	else:
		Debug.pr("stuck.")
		player.stuck = true

## undo last move ##############################################################

func undo_last_move(player):
	# remove last move from move_history
	var last_pos = player.move_history.pop_front()
	var dest_cell = cell_at_coord(last_pos)

	# need to walk back the grid's Undo markers
	var new_undo_coord = Util.first(player.move_history)
	if new_undo_coord != null:
		state.grid[new_undo_coord.y][new_undo_coord.x].append("Undo")
		# Debug.pr("undo appended (in undo)", state.grid[new_undo_coord.y])
	state.grid[dest_cell.coord.y][dest_cell.coord.x].erase("Undo")
	# Debug.pr("undo erased (in undo)", state.grid[dest_cell.coord.y])

	if last_pos == player.coord:
		Debug.pr("Player already at last coord, no undo movement required")
		# TODO animate player.node undo in place
		return

	# move player node
	# TODO animate/tween/sound/fun
	# TODO note this should be an undo animation
	# probably a func to call on player node w/ the new position
	player.node.position = dest_cell.coord * square_size

	# update game state
	state.grid[dest_cell.coord.y][dest_cell.coord.x].append("Player")
	state.grid[player.coord.y][player.coord.x].erase("Player")

	if "FlowerEaten" in state.grid[player.coord.y][player.coord.x]:
		# uneat the flower in the current player position
		uneat_flower_at_cell(cell_at_coord(player.coord))
	if "Target" in state.grid[player.coord.y][player.coord.x]:
		# unstuck when undoing from the target
		player.stuck = false

	# update state player position
	player.coord = dest_cell.coord

## move ##############################################################

# attempt to move all players in move_dir
# any undos (movement backwards) undos the last movement
# if any player is stuck, only undo is allowed
# otherwise, the player moves to the flower or target in the direction pressed
func move(move_dir):
	var moves_to_make = []
	for p in state.players:
		var cells = cells_in_dir(p.coord, move_dir)
		if len(cells) == 0:
			if p.stuck:
				Debug.warn("stuck.", p.stuck)
				moves_to_make.append(["stuck", null, p])
			# TODO express/animate stuck/edge move
			continue

		cells = cells.filter(func(c): return c.objs != null)
		if len(cells) == 0:
			if p.stuck:
				Debug.warn("stuck.", p.stuck)
				moves_to_make.append(["stuck", null, p])
			# TODO express/animate nothing in-direction move
			continue

		for cell in cells:
			Debug.pr(p.coord, cell.coord, cell.objs, p.move_history)
			# TODO instead of markers, read undo from the players move history?
			if "Undo" in cell.objs and cell.coord in p.move_history:
				# should be fine? worried about playerA finding playerB's undo?
				moves_to_make.append(["undo", undo_last_move, p, cell])
				break
			if p.stuck:
				Debug.warn("stuck.", p.stuck)
				moves_to_make.append(["stuck", null, p])
				break
			if "Player" in cell.objs:
				moves_to_make.append(["blocked_by_player", null, p])
				break
			if "FlowerEaten" in cell.objs:
				continue
			if "Flower" in cell.objs:
				moves_to_make.append(["flower", move_to_flower, p, cell])
				break
			if "Target" in cell.objs:
				moves_to_make.append(["target", move_to_target, p, cell])
				break
			Debug.warn("unexpected/unhandled cell in direction", cell)

	Debug.pr("move", move_dir, "moves to make", moves_to_make.map(func(m): return m[0]))

	var any_move = moves_to_make.any(func(m): return m[0] in ["flower", "target"])
	if any_move:
		Debug.pr("at least one move to make, updating all history before moving")
		for p in state.players:
			p.move_history.push_front(p.coord)

		for m in moves_to_make:
			if m[0] in ["flower", "target"]:
				Debug.pr("making move:", move_dir, m[0])
				m[1].call(m[2], m[3])

		return

	var any_undo = moves_to_make.any(func(m): return m[0] == "undo")
	if any_undo:
		Debug.pr("should undo all!")
		for m in moves_to_make:
			# TODO kind of wonky, should prolly use a dict/struct
			undo_last_move(m[2])
		# return to prevent any other moves
		return

	# var any_stuck = moves_to_make.any(func(m): return m[0] == "stuck")
	# if any_stuck:
	# 	Debug.pr("player stuck, gotta undo")
	# 	# return to prevent any other moves
	# 	return
