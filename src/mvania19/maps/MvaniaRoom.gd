@tool
class_name MvaniaRoom
extends Node2D

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

	r.position += tm.position

	return r

###########################################
# room_box

var room_box

func ensure_room_box():
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

###########################################
# roombox signals

var visited = false

func _on_room_entered(body: Node2D):
	if body.is_in_group("player"):
		visited = true
		MvaniaGame.update_room_data(self)
		MvaniaGame.update_rooms()
		body.stamp({"scale": 2.0, "ttl": 1.0})

func _on_room_exited(body: Node2D):
	if body.is_in_group("player"):
		MvaniaGame.update_room_data(self)
		MvaniaGame.update_rooms()

###########################################
# store/retrieve data from store

func to_room_data(player=null):
	var rect = used_rect()
	var data = {
		"name": name,
		"scene_file_path": scene_file_path,
		"position": position,
		"rect": rect,
		"visited": visited,
		}

	var ents = get_children()\
		.filter(func(c): return c.has_method("to_data") and c.has_method("restore"))\
		.map(func(c): return [c.name, c.to_data()])
	var ent_map = {}
	for e in ents:
		ent_map[e[0]] = e[1]
	if len(ents) > 0:
		data["entities"] = ent_map
	if area:
		data["area_name"] = area.name
	if player:
		var r = Rect2()
		r.position = rect.position + position
		r.size = rect.size
		data["has_player"] = r.has_point(player.global_position)
	return data

var area

var room_data : Dictionary :
	set(data):
		room_data = data
		if "visited" in room_data:
			if room_data["visited"]:
				visited = room_data["visited"]
				_on_paused() if paused else _on_unpaused()

		if "entities" in room_data:
			var ch_by_name = Util.get_children_by_name(self)
			for ent_key in room_data["entities"].keys():
				var ent_data = room_data["entities"][ent_key]
				var ent = ch_by_name[ent_key]
				if ent.has_method("restore"):
					ent.restore(ent_data)

###########################################
# ready

func _ready():
	ensure_room_box()
	ensure_pofs()

###########################################
# pause

var paused

func pause():
	paused = true
	if not Engine.is_editor_hint():
		deactivate_pofs()
		call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
		_on_paused()

func unpause():
	paused = false
	if not Engine.is_editor_hint():
		call_deferred("set_process_mode", PROCESS_MODE_INHERIT)
		_on_unpaused()
		call_deferred("activate_pofs")

func _on_paused():
	if visited:
		set_visible(true)
		to_faded()
	else:
		set_visible(false)

func _on_unpaused():
	set_visible(true)
	to_normal()

func reset_tweens():
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	if normal_tween and normal_tween.is_valid():
		normal_tween.kill()

var fade_tween
func to_faded():
	if normal_tween and normal_tween.is_valid():
		normal_tween.kill()
	fade_tween = create_tween()
	fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	fade_tween.tween_property(self, "modulate:a", 0.2, 0.3)

var normal_tween
func to_normal():
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	normal_tween = create_tween()
	normal_tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	normal_tween.tween_property(self, "modulate:a", 1, 0.2)

###########################################
# pofs

var pof_scene = preload("res://addons/camera/CamPOF.tscn")
var auto_pof_group = "auto_pofs"

func ensure_pofs():
	for c in get_children():
		if c.is_in_group(auto_pof_group):
			c.free()

	var rect = used_rect()
	var points = [rect.position, rect.end]

	for p in points:
		var auto_pof = pof_scene.instantiate()
		auto_pof.add_to_group(auto_pof_group, true)
		auto_pof.position = p
		add_child(auto_pof)
		auto_pof.set_owner(self)

func deactivate_pofs():
	var pofs = Util.get_children_in_group(self, Cam.pof_group)
	for p in pofs:
		if p.has_method("deactivate"):
			p.deactivate()
	# Cam.update_pofs()

func activate_pofs():
	var pofs = Util.get_children_in_group(self, Cam.pof_group)
	for p in pofs:
		if p.has_method("activate"):
			p.activate()
	# Cam.update_pofs()
