@tool
class_name MvaniaRoom
extends Node2D

func prn(msg, msg2=null, msg3=null, msg4=null):
	if msg4:
		print("[MvaniaRoom ", name, "]: ", msg, msg2, msg3, msg4)
	elif msg3:
		print("[MvaniaRoom ", name, "]: ", msg, msg2, msg3)
	elif msg2:
		print("[MvaniaRoom ", name, "]: ", msg, msg2)
	else:
		print("[MvaniaRoom ", name, "]: ", msg)

###########################################
# tilemaps

func tilemaps() -> Array[TileMap]:
	var tmaps: Array[TileMap] = []
	for c in get_children():
		if c is TileMap:
			tmaps.append(c)
	return tmaps

###########################################
# rects

func tilemap_rect() -> Rect2i:
	var tm: TileMap
	for tmap in tilemaps():
		tm = tmap
		# TODO select/combine tilemap rect building, likely with rect2.merge
		break

	if not tm:
		push_error("MvaniaRoom without tilemap, returning zero rect")
		return Rect2i()

	return tm.get_used_rect()

func used_rect() -> Rect2:
	var tm: TileMap
	for tmap in tilemaps():
		tm = tmap
		# TODO select/combine tilemap rect building, likely with rect2.merge
		break

	if not tm:
		push_error("MvaniaRoom without tilemap, returning zero rect")
		return Rect2()

	var tm_rect = tm.get_used_rect()
	var r = Rect2()
	var tile_size = tm.tile_set.tile_size
	var v_half_tile_size = tile_size / 2.0
	r.position = tm.map_to_local(tm_rect.position) - v_half_tile_size
	r.end = tm.map_to_local(tm_rect.end) - v_half_tile_size

	return r

###########################################
# persisted

func to_room_data(room=self):
	return {
		"name": room.name,
		"scene_file_path": room.scene_file_path,
		"position": room.position,
		"rect": room.used_rect(),
		# TODO player spawn points
		# TODO enemies spawns/data
		# TODO pickup spawns/data
		}

###########################################
# room_box

var room_box

func add_room_box():
	for c in get_children():
		if c.name == "RoomBox":
			c.free()

	# room rect
	var rect = used_rect()

	# shape
	var shape = RectangleShape2D.new()
	shape.size = rect.size

	# collision shape
	var coll = CollisionShape2D.new()
	coll.set_shape(shape)
	coll.position = rect.position + (rect.size / 2.0)

	# area2D
	room_box = Area2D.new()
	room_box.add_child(coll)
	room_box.name = "RoomBox"
	room_box.set_collision_layer_value(1, false)
	room_box.set_collision_mask_value(1, false)
	room_box.set_collision_mask_value(2, true) # 2 for player
	room_box.set_visible(false)

	# signals
	room_box.body_entered.connect(_on_room_entered)
	room_box.body_exited.connect(_on_room_exited)

	# add child, set owner
	add_child(room_box)
	room_box.set_owner(self)

func _on_room_entered(body: Node2D):
	if body.is_in_group("player"):
		MvaniaGame.update_current_rooms()

func _on_room_exited(body: Node2D):
	if body.is_in_group("player"):
		MvaniaGame.update_current_rooms()

###########################################
# ready

var room_data : Dictionary :
	set(data):
		room_data = data

func _ready():
	prn("Room ready: ", used_rect(), " ", used_rect().end)
	if len(room_data):
		prn("room data: ", room_data)

	add_room_box()

###########################################
# pause

func pause():
	set_process(false)

func unpause():
	set_process(true)
