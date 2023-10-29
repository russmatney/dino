@tool
extends BrickRoom
class_name WoodsRoom

##########################################################################
## static ##################################################################

enum t {START, END, SQUARE, LONG, CLIMB, FALL}

## create room ##################################################################

static func create_room(opts):
	var room = WoodsRoom.new()

	opts["tilemap_scene"] = load("res://addons/reptile/tilemaps/CaveTiles16.tscn")

	opts["label_to_entity"] = {
		"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
		"Leaf": {scene=load("res://src/woods/entities/Leaf.tscn")},

		# not used (at the time of writing), but maybe a quick win idea
		"Spawn": {scene=load("res://src/dino/SpawnPoint.tscn")},
# 		var spawn_point = spawn_point_scene.instantiate()
# 		spawn_point.position = l * coord_factor
# 		spawn_point.spawn_scene = leaf_scene
# 		spawn_point.name = "LeafSpawnPoint_%s_%s" % [l.x, l.y]
		"Light": {scene=load("res://src/pluggs/entities/Light.tscn")},
		}

	var typ = Util.get_(opts, "type", t.SQUARE)
	room.type = typ

	opts["filter_rooms"] = func(r):
		var type_s
		match room.type:
			t.START: type_s = "START"
			t.END: type_s = "END"
			t.SQUARE: type_s = "SQUARE"
			t.CLIMB: type_s = "CLIMB"
			t.FALL: type_s = "FALL"
			t.LONG: type_s = "LONG"

		if type_s != null:
			return type_s == r.meta.get("room_type")

	room.gen(opts)

	# add detection for end-reached
	if room.type == t.END:
		var shape = RectangleShape2D.new()
		shape.size = room.rect.size
		var coll = CollisionShape2D.new()
		coll.name = "CollisionShape2D"
		coll.set_shape(shape)
		coll.position = room.rect.position + (room.rect.size / 2.0)

		var box = Area2D.new()
		box.add_child(coll)
		coll.set_owner(box)
		box.name = "EndBox"
		box.set_collision_layer_value(1, false)
		box.set_collision_mask_value(1, false)
		box.set_collision_mask_value(2, true) # 2 for player

		room.end_box = box
		room.add_child(box)

	return room

##############################################################################
## instance ##################################################################

var type
var spawn_points = []
var end_box

## ready ##################################################################

func _ready():
	spawn({only_if=func(sp): return len(sp.get_children()) == 0})
	if end_box == null:
		end_box = get_node_or_null("EndBox")
	if end_box != null:
		Util._connect(end_box.body_entered, _on_end_entered)

func _on_end_entered(body):
	Debug.pr("entered?", body)
	if body.is_in_group("player"):
		if body.has_method("entered_end_box"):
			body.entered_end_box()

## spawn ##################################################################

func spawn(opts=null):
	for ch in get_children():
		# should be DinoSpawnPoint
		if ch is Marker2D:
			if opts != null and "only_if" in opts:
				if opts.only_if.call(ch):
					spawn_one(ch)
			else:
				spawn_one(ch)

func spawn_one(sp):
	var new_ent = sp.spawn_entity()
	if new_ent != null:
		var o = get_owner()
		new_ent.ready.connect(func(): new_ent.set_owner(o))
		sp.add_child(new_ent)
