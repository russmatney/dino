@tool
class_name MvaniaRoom
extends Node2D

func prn(msg, msg2=null, msg3=null):
	if msg3:
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
# ready

func _ready():
	print("Room ready: ", name, " ", tilemap_rect(), " ", used_rect(), " ", used_rect().end)
