@tool
class_name MetroRoom
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
		push_error("MetroRoom without tilemap, returning zero rect")
		return Rect2i()

	return tm.get_used_rect()

func used_rect() -> Rect2:
	var tm: TileMap
	for tmap in tilemaps():
		tm = tmap
		# TODO select/combine tilemap rect building, likely with rect2.merge
		break

	if not tm:
		push_error("MetroRoom without tilemap, returning zero rect")
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
		Hotel.check_in(self, hotel_data(body))
		Metro.update_zone()

		for ch in get_children():
			if ch.has_method("on_room_entered"):
				# doors toggling focus properly
				ch.on_room_entered()


func _on_room_exited(body: Node2D):
	if body.is_in_group("player"):
		Hotel.check_in(self, hotel_data(body))
		Metro.update_zone()

###########################################
# Hotel store/retrieve data

func hotel_data(player=null):
	var rect = used_rect()
	var data = {
		"name": name,
		"scene_file_path": scene_file_path,
		"position": position,
		"rect": rect,
		"visited": visited,
		}

	if player and is_instance_valid(player):
		var r = Rect2()
		r.position = rect.position + position
		r.size = rect.size
		data["has_player"] = r.has_point(player.global_position)
	return data

func check_out(data):
	room_data = data

var room_data : Dictionary :
	set(data):
		room_data = data
		if "visited" in room_data:
			if room_data["visited"]:
				visited = room_data["visited"]
				_on_paused() if paused else _on_unpaused()

###########################################################
# enter tree

func _enter_tree():
	add_to_group("metro_rooms", true)

###########################################
# ready

var zone

func _ready():
	Hotel.register(self)

	ensure_room_box()
	ensure_cam_points()

	Game.maybe_spawn_player.call_deferred()

	var p = get_parent()
	if p is MetroZone:
		zone = p


###########################################
# pause

var paused

func pause():
	paused = true
	if not Engine.is_editor_hint():
		deactivate_cam_points()
		_on_paused()
		set_process_mode.call_deferred(PROCESS_MODE_DISABLED)

func unpause():
	paused = false
	if not Engine.is_editor_hint():
		set_process_mode.call_deferred(PROCESS_MODE_INHERIT)
		_on_unpaused()
		activate_cam_points.call_deferred()

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
	reset_tweens()
	fade_tween = create_tween()
	if fade_tween and fade_tween.is_valid():
		fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		fade_tween.tween_property(self, "modulate:a", 0.2, 0.3)

var normal_tween
func to_normal():
	reset_tweens()
	normal_tween = create_tween()
	if normal_tween and normal_tween.is_valid():
		normal_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		normal_tween.tween_property(self, "modulate:a", 1, 0.2)

###########################################
# cam points

var pof_scene = preload("res://addons/camera/CamPOF.tscn")
var auto_pof_group = "auto_pofs"
var poa_scene = preload("res://addons/camera/CamPOA.tscn")
var auto_poa_group = "auto_poas"
var poi_scene = preload("res://addons/camera/CamPOI.tscn")
var auto_poi_group = "auto_pois"

func create_point(scene, auto_group, pos):
	var auto_point = scene.instantiate()
	auto_point.add_to_group(auto_group, true)
	auto_point.position = pos

	# only relevant for POIs
	# auto_point.importance = 0.4

	add_child(auto_point)
	auto_point.set_owner(self)

func ensure_cam_points():
	for c in get_children():
		if c.is_in_group(auto_poi_group):
			c.free()

	var rect = used_rect()
	var points = [rect.position, rect.end,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + Vector2(0, rect.size.y)]

	for p in points:
		create_point(poa_scene, auto_poa_group, p)

func deactivate_cam_points():
	var poas = Util.get_children_in_group(self, Cam.poa_group)
	for p in poas:
		if p.has_method("deactivate"):
			p.deactivate()

	var pofs = Util.get_children_in_group(self, Cam.pof_group)
	for p in pofs:
		if p.has_method("deactivate"):
			p.deactivate()

	var pois = Util.get_children_in_group(self, Cam.poi_group)
	for p in pois:
		if p.has_method("deactivate"):
			p.deactivate()

func activate_cam_points():
	var poas = Util.get_children_in_group(self, Cam.poa_group)
	for p in poas:
		if p.has_method("activate"):
			p.activate()

	var pofs = Util.get_children_in_group(self, Cam.pof_group)
	for p in pofs:
		if p.has_method("activate"):
			p.activate()

	var pois = Util.get_children_in_group(self, Cam.poi_group)
	for p in pois:
		if p.has_method("activate"):
			p.activate()