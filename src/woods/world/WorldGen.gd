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

func generate():
	# clear
	rooms_node.get_children().map(func(c): c.free())

	# reset
	room_idx = 0

	# generate
	Debug.pr("Generating world")

	# first room
	var last = create_room({type=WoodsRoom.t.START})
	var last_room = last["room"]
	var last_opts = last["opts"].duplicate(true)

	# most rooms
	for _i in range(room_count - 2):
		var next_room_opts = WoodsRoom.room_opts(last_room, last_opts)
		last = create_room(next_room_opts)
		last_room = last["room"]
		last_opts = last["opts"].duplicate(true)

	# last room
	var end_opts = {type=WoodsRoom.t.END}
	create_room(WoodsRoom.room_opts(last_room, last_opts, end_opts))

## create_room ######################################################################

func create_room(opts=null):
	if opts == null:
		opts = {}
	var room = WoodsRoom.create_room(opts)

	room_idx += 1
	rooms_node.add_child(room)

	return {room=room, opts=opts}
