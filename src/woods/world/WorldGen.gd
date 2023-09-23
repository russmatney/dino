@tool
extends Node2D

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v:
			generate()

@export var room_base_dim = 512
@export var room_count = 5

@onready var rooms_node = $%Rooms

var room_idx = 0

## ready ######################################################################

func _ready():
	if Engine.is_editor_hint():
		Debug.pr("World Gen ready")

## generate ######################################################################

enum t {NORM, LONG, CLIMB, FALL}

func generate():
	# clear
	rooms_node.get_children().map(func(c): c.free())

	# reset
	room_idx = 0

	# generate
	Debug.pr("Generating world")

	# first room
	var last_rect = create_room()
	var last_opts

	# most rooms
	for _i in range(room_count - 2):
		last_opts = room_opts(last_rect, last_opts)
		last_rect = create_room(last_opts)

	# last room
	var opts = room_opts(last_rect, last_opts, {type=t.NORM})
	create_room(opts)

func room_opts(last_rect, last_opts={}, overrides={}):
	var type = overrides.get("type")
	if type == null:
		type = Util.rand_of([t.NORM, t.LONG, t.CLIMB, t.FALL])

	var size
	match type:
		t.NORM: size = Vector2.ONE * room_base_dim
		t.CLIMB, t.FALL: size = Vector2.ONE * room_base_dim * Vector2(1, 2)
		t.LONG: size = Vector2.ONE * room_base_dim * Vector2(2, 1)

	var pos
	match type:
		t.NORM, t.FALL, t.LONG: pos = Vector2(
			last_rect.position.x + last_rect.size.x, last_rect.position.y
			)
		t.CLIMB: pos = Vector2(
			last_rect.position.x + last_rect.size.x,
			last_rect.position.y + last_rect.size.y - size.y,
			)
	if last_opts:
		match [last_opts.type, type]:
			[t.CLIMB, t.CLIMB]: pos.y -= room_base_dim
			[_, t.CLIMB]: pass
			[t.FALL, _]: pos.y += room_base_dim

	var color
	match type:
		t.NORM: color = Color.PERU
		t.LONG: color = Color.FUCHSIA
		t.FALL: color = Color.CRIMSON
		t.CLIMB: color = Color.AQUAMARINE

	return {position=pos, size=size, type=type, color=color}

## create_room ######################################################################

func create_room(opts={}):
	Debug.pr("Creating room", opts)
	var rect = ColorRect.new()
	rect.position = opts.get("position", Vector2.ZERO)
	rect.size = opts.get("size", Vector2.ONE * room_base_dim)

	var color = opts.get("color")
	if color == null:
		match room_idx % 3:
			0: color = Color.PERU
			1: color = Color.AQUAMARINE
			2: color = Color.CRIMSON
	rect.color = color
	room_idx += 1

	rooms_node.add_child(rect)

	return rect
