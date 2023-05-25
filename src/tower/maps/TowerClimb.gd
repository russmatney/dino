@tool
extends Node2D

var tiles
var player
var enemies = []

@onready var break_the_targets = $BreakTheTargets

@export var level_num: String


## ready ####################################################################

var scene_ready = false

func _ready():
	scene_ready = true
	calc_rect()

	Hood.notif(str("Begin Level ", level_num))
	break_the_targets.targets_cleared.connect(_on_targets_cleared)
	Game.player_found.connect(_on_player_found)

	Game.maybe_spawn_player()

## player pickups ####################################################################

func _on_player_found(p):
	player = p
	p.pickups_changed.connect(_on_player_pickups_changed)


func _on_player_pickups_changed(pickups):
	if "hat" in pickups and "body" in pickups:
		# TODO animate assembly/enemy spawning
		# anim the items flying to the spot?
		Hood.notif("Robot Assembled")

		var enemy_spawners = get_tree().get_nodes_in_group("enemy_spawner")
		enemy_spawners.shuffle()
		if enemy_spawners:
			var en = Tower.spawn_enemy(enemy_spawners[0].global_position)
			en.dead.connect(_on_robot_destroyed)
			enemies.append(en)
			# Hood.hud.update_enemies_remaining(enemies_alive().size())

		# clear player items
		player.pickups = []
		player.pickups_changed.emit(player.pickups)

## enemies ####################################################################

func enemies_alive():
	var es = []
	for e in enemies:
		if e and is_instance_valid(e) and not e.is_dead:
			es.append(e)
	return es

func _on_robot_destroyed():
	Hood.notif("Robot Destroyed!")
	# TODO move to writing/reading via Hotel
	# Hood.hud.update_enemies_remaining(enemies_alive().size())
	for e in enemies:
		if not e.is_dead:
			robots_destroyed = false
			return
	robots_destroyed = true
	player.notif("All robots destroyed!")
	check_win()

## targets ####################################################################

func _on_targets_cleared():
	Hood.notif("Targets Destroyed!")
	player.notif("All targets destroyed!")
	targets_destroyed = true
	check_win()


## physics ####################################################################

func _physics_process(_delta):
	wrap_thing(player)

func wrap_thing(thing):
	# TODO disable camera smoothing if we're wrapping across
	if thing and is_instance_valid(thing):
		thing.position.x = wrapf(thing.position.x, rect.position.x, rect.end.x)
		thing.position.y = wrapf(thing.position.y, rect.position.y, rect.end.y)


######################################################################
# triggers

@export var recalc_rect: bool : set = do_calc_rect


func do_calc_rect(_v):
	if scene_ready:
		calc_rect()


@export var clear: bool : set = do_clear


func do_clear(_v):
	if scene_ready:
		for c in get_children():
			c.queue_free()


@export var regen_all: bool : set = do_regen_all_rooms


func do_regen_all_rooms(_v):
	if scene_ready:
		regen_all_rooms()


func regen_all_rooms():
	if not Engine.is_editor_hint():
		Hood.notif("generating new rooms")
	for t in get_tree().get_nodes_in_group("targets"):
		t.queue_free()

	for r in rooms():
		# only works if rooms are 'scene_ready'
		r.n_seed += randi() % 5

	break_the_targets.setup()


# TODO restore export (String, "middle", "end")
@export var next_room_type = "middle" : set = set_next_room_type


func set_next_room_type(val):
	next_room_type = val


######################################################################
# build tower


func rooms():
	var rs = []
	for c in get_children():
		if c is TowerRoom:
			rs.append(c)
	return rs


func get_start_room():
	for r in rooms():
		if r.is_in_group("tower_start_room"):
			return r


func get_previous_room():
	var rs = rooms()
	return rs.back()


######################################################################
# add neighboring room

var start_room_scene = preload("res://src/tower/rooms/TowerStartRoom.tscn")
var middle_room_scene = preload("res://src/tower/rooms/TowerMiddleRoom.tscn")
var end_room_scene = preload("res://src/tower/rooms/TowerEndRoom.tscn")

@export var cell_size: int = 16
@export var img_size: int = 50


func add_room_inst(room_scene):
	var room = room_scene.instantiate()
	add_child(room)
	room.set_owner(self)
	room.cell_size = cell_size
	room.img_size = img_size
	room.setup()
	room.regen_tilemaps()
	return room


@export var add_room: bool : set = do_add_room


func do_add_room(_v):
	if scene_ready:
		var start_room = get_start_room()
		if not start_room:
			add_room_inst(start_room_scene)
		elif next_room_type == "middle":
			add_room_inst(middle_room_scene)
		elif next_room_type == "end":
			add_room_inst(end_room_scene)

		rect = calc_rect()


######################################################################
# calc rect

var rect


func calc_rect():
	var new_rect = Rect2()
	for r in rooms():
		var rr = r.calc_rect_global()
		new_rect = new_rect.merge(rr)

	rect = new_rect
	return rect

######################################################################
# collect tiles

func collect_tiles():
	var ts = []
	ts.append_array(get_tree().get_nodes_in_group("bluetile"))
	ts.append_array(get_tree().get_nodes_in_group("redtile"))
	ts.append_array(get_tree().get_nodes_in_group("darktile"))
	ts.append_array(get_tree().get_nodes_in_group("yellowtile"))
	return ts


######################################################################
# win

var targets_destroyed
var robots_destroyed


func check_win():
	if targets_destroyed and robots_destroyed:
		Hood.notif(str("Level ", level_num, " Complete!"))
		player.notif("Level Clear!")
		Tower.level_complete()
