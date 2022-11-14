tool
extends Node

# TODO dry up
var block_spawners_group_name = "block_spawners"

onready var block_scene = preload("res://src/runner/gravity/Block.tscn")

# TODO consider validation/configuration warning here
# e.g. ensure the groups being used are used in the scene

func create_new_block(pos2d):
	if not block_scene:
		return

	var new_block = block_scene.instance()
	new_block.position = pos2d.position
	call_deferred("add_child", new_block)

func ensure_blocks(room):
	var existing_blocks = Util.get_children_in_group(room, "block")
	if existing_blocks:
		return

	var xs = Util.get_children_in_group(room, block_spawners_group_name)
	for x in xs:
		create_new_block(x)

func cleanup_blocks(room):
	for block in Util.get_children_in_group(room, "block"):
		block.queue_free()


func _ready():
	print("runner/Blocks ready()")
