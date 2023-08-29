@tool
class_name MetroRoom
extends Node2D


@export var debugging = false

## enter tree ##########################################################

func _enter_tree():
	add_to_group(Metro.rooms_group, true)

## ready ##########################################

var zone

func _ready():
	Hotel.register(self)

	get_parent().ready.connect(ensure_room_box)
	ensure_cam_points()

	var p = get_parent()
	if p is MetroZone:
		zone = p

## hotel ##########################################

func hotel_data(player=null, has_player=null):
	var rect = used_rect()
	var data = {
		name=name,
		scene_file_path=scene_file_path,
		position=position,
		rect=rect,
		visited=visited,
		}

	if has_player != null:
		data["has_player"] = has_player
	else:
		data["has_player"] = contains_player(player)
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

# roombox signals ###########################################

var visited = false

func _on_room_entered(body: Node2D):
	if body.is_in_group("player"):
		visited = true
		Hotel.check_in(self, hotel_data(body, true))
		Metro.update_zone()

		for ch in get_children():
			if ch.has_method("on_room_entered"):
				# doors toggling focus properly
				ch.on_room_entered()


func _on_room_exited(body: Node2D):
	if body.is_in_group("player"):
		Hotel.check_in(self, hotel_data(body, false))
		Metro.update_zone()


# tilemaps ###########################################

func tilemaps() -> Array[TileMap]:
	var tmaps: Array[TileMap] = []
	for c in get_children():
		if c is TileMap:
			tmaps.append(c)
	return tmaps

## rects ##########################################

func tilemap_to_rect(tm: TileMap) -> Rect2:
	var tm_rect = tm.get_used_rect()
	var r = Rect2()
	var tile_size = tm.tile_set.tile_size
	var v_half_tile_size = tile_size / 2.0
	r.position = tm.map_to_local(tm_rect.position) - v_half_tile_size
	r.end = tm.map_to_local(tm_rect.end) - v_half_tile_size

	r.position += tm.position

	return r

func used_rect() -> Rect2:
	var r = Rect2()
	for tmap in tilemaps():
		var t_rect = tilemap_to_rect(tmap)
		if r.position == Vector2.ZERO:
			r.position = t_rect.position
		r = r.merge(t_rect)
	return r

func contains_player(player):
	if player == null or not is_instance_valid(player):
		return

	if room_box != null:
		var room_box_contains = room_box.overlaps_body(player)
		if room_box_contains:
			return true
		else:
			return false
	else:
		Debug.warn("null room box for room", self)

	var rect = used_rect()
	rect.position += position

	if player.has_method("get_rect") and player.get_rect() and rect.intersects(player.get_rect()):
		return true
	elif rect.has_point(player.global_position):
		return true

	return false

## room_box ##########################################

var room_box

func room_box_name():
	return "RoomBox_%s" % self.name

func ensure_room_box():
	var existing = []
	for c in get_parent().get_children():
		if c.name == room_box_name():
			existing.append(c)

	if len(existing) > 0:
		Debug.pr("renaming and freeing room box", existing)
		existing.map(func(c):
			c.name = "RoomBox_ToDelete"
			c.free())

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
	room_box.name = room_box_name()
	room_box.set_collision_layer_value(1, false)
	room_box.set_collision_mask_value(1, false)
	room_box.set_collision_mask_value(2, true) # 2 for player
	room_box.set_collision_mask_value(4, true) # 4 for enemies
	room_box.position = self.position
	room_box.set_visible(false)

	# signals
	Util._connect(room_box.body_entered, _on_room_entered)
	Util._connect(room_box.body_exited, _on_room_exited)

	# add child to parent, so room_boxes don't get paused along with rooms
	get_parent().add_child.call_deferred(room_box)

## move children ##########################################

var children_moved = false
func move_children_up():
	if children_moved:
		return
	for c in get_children():
		if c.is_in_group("enemies"):
			c.reparent.call_deferred(get_parent(), true)
	children_moved = true

## pause ##########################################

var paused
var paused_ents = []

func pause(opts={}):
	paused = true

	if room_box != null:
		var ents_to_pause = room_box.get_overlapping_bodies()
		ents_to_pause.append_array(room_box.get_overlapping_areas())
		var chs = get_children()
		ents_to_pause = ents_to_pause.filter(func(ent): return not ent in chs)
		if len(ents_to_pause) > 0:
			Debug.pr("paused room contains ents to pause", ents_to_pause)
			for ent in ents_to_pause:
				ent.set_process_mode.call_deferred(PROCESS_MODE_DISABLED)
				paused_ents.append(ent)
				# TODO paused ents should move back to IDLE
				# (and attackers on player should be re-calced)

	if not Engine.is_editor_hint():
		if not opts.get("process_only"):
			_on_paused()
		set_process_mode.call_deferred(PROCESS_MODE_DISABLED)

func unpause(opts={}):
	paused = false
	if not Engine.is_editor_hint():
		set_process_mode.call_deferred(PROCESS_MODE_INHERIT)
		if not opts.get("process_only"):
			_on_unpaused()

		# moved children up to the zone level
		move_children_up()

		# unpause any ents we paused
		for ent in paused_ents:
			ent.set_process_mode.call_deferred(PROCESS_MODE_INHERIT)
		paused_ents = []


func _on_paused():
	deactivate_cam_points()
	if visited:
		set_visible(true)
		to_faded()
	else:
		set_visible(false)

func _on_unpaused():
	activate_cam_points.call_deferred()
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

## cam points ##########################################

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
