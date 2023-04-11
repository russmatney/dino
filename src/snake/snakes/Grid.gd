@tool
extends Node2D

###########################################################################
# exports/vars

@export var width = 16 : set = set_width # (int, 2, 24)
@export var height = 16 : set = set_height # (int, 2, 24)
@export var cell_size: int = 8 : set = set_cell_size
@export var enemy_count: int = 1


func set_width(v):
	width = v
	if Engine.is_editor_hint() and scene_ready:
		init_grid()


func set_height(v):
	height = v
	if Engine.is_editor_hint() and scene_ready:
		init_grid()


func set_cell_size(v):
	cell_size = v
	if Engine.is_editor_hint() and scene_ready:
		init_grid()


###########################################################################
# ready


var scene_ready
func _ready():
	setup.call_deferred()
	scene_ready = true

func setup():
	init_grid()
	init_food()
	for _i in range(enemy_count):
		add_enemy()


###########################################################################
# grid


func all_cell_coords():
	var cs := []
	for x in range(width):
		for y in range(height):
			cs.append(Vector2(x, y))
	return cs


func random_coord():
	var all = all_cell_coords()
	return all[randi() % all.size()]


func all_empty_coords():
	var coords = all_cell_coords()
	for s in snakes:
		if is_instance_valid(s):
			for c in s.segment_coords:
				coords.erase(c)
	for f in food:
		coords.erase(f.coord)

	return coords

func random_empty_coord(exclude=null):
	var coords = all_empty_coords()
	if exclude:
		coords.erase(exclude)
	if coords:
		return Util.rand_of(coords)


func wrap_edges(next):
	# wrap next coord against the grid's edges
	next.x = wrapi(next.x, 0, width)
	next.y = wrapi(next.y, 0, height)
	return next

func coord_to_position(coord):
	return coord * cell_size


###########################################################################
# cells

func get_cell(coord):
	if coord in cells:
		# TODO consider returning food or snake segment (or enemy?)
		return cells[coord]
	else:
		Debug.pr("[WARN] no coord in grid!")

func all_cells():
	return cells.values()

func food_cells():
	return food

func untouched_cells():
	var untouched = []
	for c in all_cells():
		if c.animation == "yellow":
			untouched.append(c)
	return untouched


# dicts for cells might be better here
func cell_info_at(coord, from=null):
	for s in snakes:
		if is_instance_valid(s):
			for c in s.segment_coords:
				if coord == c:
					return ["snake", s]

	for f in food:
		if coord == f.coord:
			return ["food", f]

		if not from == null:
			# next is same x/y as food AND same x/y as from
			if (coord.x == f.coord.x and from.x == coord.x) or (coord.y == f.coord.y and from.y == coord.y):
				return ["facing_food", f]

	for c in all_cell_coords():
		if coord == c:
			return "empty"

###########################################################################
# cell anims

signal cell_touched(coord)

func mark_touched(coord):
	var cell = get_cell(coord)
	if cell:
		cell.animation = "blue"
		Util.set_random_frame(cell)
		cell_touched.emit(coord)

func mark_cells_playing():
	for c in all_cells():
		c.playing = true

func mark_cells_not_playing():
	for c in all_cells():
		c.playing = false

func deform_all_cells():
	for c in all_cells():
		c.deform(Vector2.ONE * 0.9)

# func animate_cell_size():
# 	var t = create_tween()
# 	var og_cell_size = cell_size
# 	t.tween_property(self, "cell_size", cell_size * 2, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
# 	t.tween_property(self, "cell_size", og_cell_size, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

###########################################################################
# init grid

@onready var cell_scene = preload("res://src/snake/snakes/Cell.tscn")
var cells = {}


func init_grid(anim = "yellow"):
	for c in $Cells.get_children():
		if c.is_in_group("cells"):
			c.free()

	for coord in all_cell_coords():
		var c = cell_scene.instantiate()
		c.coord = coord
		c.animation = anim
		Util.set_random_frame(c)
		c.position = coord_to_position(coord)
		$Cells.add_child(c)

		cells[coord] = c

	# deform_all_cells()

###########################################################################
# init player

var snakes = []
@onready var player_scene = preload("res://src/snake/snakes/Player.tscn")

func add_snake():
	var initial_cell = random_coord()
	var initial_direction = Vector2.RIGHT
	var p = player_scene.instantiate()
	snakes.append(p)
	add_child(p)
	p.init(self, initial_cell, initial_direction)

###########################################################################
# init enemy

@onready var enemy_scene = preload("res://src/snake/snakes/Enemy.tscn")

func add_enemy():
	Debug.pr("adding enemy to grid")
	var initial_cell = random_coord()
	var initial_direction = Vector2.RIGHT
	var e = enemy_scene.instantiate()
	snakes.append(e)
	add_child(e)
	e.init(self, initial_cell, initial_direction)

###########################################################################
# init food

var food = []


func init_food():
	for f in food:
		f.free()
	for f in get_children():
		if f.is_in_group("food"):
			f.free()

	add_food()


@onready var food_scene = preload("res://src/snake/Food.tscn")

func add_food(exclude=null):
	var empty_cell = random_empty_coord(exclude)
	if empty_cell == null:
		Debug.pr("[SNAKE] No empty cells! Cannot place food.")
		return

	var f = food_scene.instantiate()
	f.coord = empty_cell
	Util.set_random_frame(f)
	f.position = coord_to_position(empty_cell)
	add_child(f)
	food.append(f)


func remove_food(f):
	food.erase(f)
	f.queue_free()
