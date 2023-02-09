@tool
extends Node

# TODO dry up
var block_spawners_group_name = "block_spawners"

@onready var block_scene = preload("res://src/runner/gravity/Block.tscn")
var block_script = "res://src/runner/gravity/Block.gd"

# TODO consider validation/configuration warning here
# e.g. ensure the groups being used are used in the scene


func create_new_block(room, spawner):
	if not block_scene:
		return

	var new_block = block_scene.instantiate()
	# new_block.script = block_script
	new_block.position = spawner.position

	# attach spawner to block
	new_block.spawner = spawner

	room.call_deferred("add_child", new_block)


func ensure_blocks(room):
	var existing_blocks = get_blocks(room)
	if existing_blocks:
		return

	var xs = Util.get_children_in_group(room, block_spawners_group_name)
	for spawner in xs:
		create_new_block(room, spawner)


func cleanup_blocks(room):
	for block in get_blocks(room):
		block.queue_free()


func get_blocks(room):
	return Util.get_children_in_group(room, "block")


func _ready():
	pass
