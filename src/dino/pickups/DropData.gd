@tool
extends Resource
class_name DropData

## data ##############################################

# TODO move away from unscalable enum (adding new values breaks existing data b/c the val is an int)
enum T {
	RANDOM,
	ORB,
	COIN,
	GEM,
	LEAF,
	POWERUP,
	}

static func all_types():
	return [T.RANDOM, T.ORB, T.COIN, T.GEM, T.LEAF, T.POWERUP]

static func all_primitive_types():
	return [T.ORB, T.COIN, T.GEM, T.LEAF, T.POWERUP]

static func add_drop(node, dd: DropData = null):
	if not dd:
		dd = DropData.new()

	var pickup_scene = load("res://src/dino/pickups/Pickup.tscn")
	var ps = pickup_scene.instantiate()
	ps.drop_data = dd

	node.add_child(ps)


## vars ##############################################

@export var type: T :
	set(v):
		type = v
		set_type_defaults(v)
@export var anim_scene: PackedScene

# can cook? can be delivered?
var data: Dictionary

func to_pretty():
	return ["Drop", type_to_str(), data]

func type_to_str():
	var t = "no-type"
	match type:
		T.RANDOM:
			t = "random"
		T.ORB:
			t = "orb"
		T.COIN:
			t = "coin"
		T.GEM:
			t = "gem"
		T.LEAF:
			t = "leaf"
		T.POWERUP:
			t = "powerup"
	return t

## init ##############################################

func _init(t: T = T.RANDOM, d: Dictionary = {}):
	type = t
	data = d

	if type == T.RANDOM:
		type = U.rand_of(DropData.all_primitive_types())

func set_type_defaults(typ: T):
	if type != typ:
		type = typ
	# these aren't exactly anim scenes....
	match type:
		T.ORB:
			anim_scene = load("res://src/dino/entities/GreenBlobAnim.tscn")
		T.COIN:
			anim_scene = load("res://src/dino/entities/coins/Coin.tscn")
		T.GEM:
			anim_scene = load("res://src/dino/entities/coins/ShrineGem.tscn")
		T.LEAF:
			anim_scene = load("res://src/dino/entities/leaves/Leaf.tscn")
		T.POWERUP:
			anim_scene = load("res://src/dino/entities/RedBlobAnim.tscn")

################################################

func add_anim_scene(node):
	if anim_scene:
		var anim = anim_scene.instantiate()
		node.add_child(anim)
