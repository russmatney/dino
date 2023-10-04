@tool
extends Node2D

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v and Engine.is_editor_hint():
			generate()

@export var room_base_dim = 512
@export var room_count = 5

@onready var rooms_node = $%Rooms
@onready var player = $%Player
var player_pos

var room_idx = 0

## ready ######################################################################

func _ready():
	if Engine.is_editor_hint():
		Debug.pr("World Gen ready")
	else:
		Debug.pr("World Gen test ready")

		player_pos = player.position

func _unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if Trolley.is_restart(event):
		Debug.pr("Regen + restart")
		generate()
		player.position = player_pos

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

	# most rooms
	for _i in range(room_count - 2):
		var next_room_opts = WoodsRoom.next_room_opts(last_room)
		last = create_room(next_room_opts)
		last_room = last["room"]

	# last room
	var opts = {type=WoodsRoom.t.END}
	create_room(WoodsRoom.next_room_opts(last_room, opts))

## create_room ######################################################################

func create_room(opts=null):
	if opts == null:
		opts = {}
	var room = WoodsRoom.create_room(opts)

	room_idx += 1
	room.ready.connect(func():
		room.set_owner(self)
		room.rect.set_owner(self)
		room.tilemap.set_owner(self))
	room.name = "Room_%s" % room_idx
	rooms_node.add_child(room)

	return {room=room, opts=opts}
