tool
extends RunnerRoom

var max_runs = 3
var runs = 0

func _ready():
	Util.ensure_connection(self, "player_entered", self, "_on_player_entered")
	Util.ensure_connection(self, "player_exited", self, "_on_player_exited")

	setup()

	if Engine.editor_hint:
		request_ready()

func setup():
	.setup()

	spawn_blocks()

onready var block_scene = preload("res://src/runner/gravity/Block.tscn")

func spawn_blocks():
	var xs = Util.get_children_in_group(self, "block_spawn")
	print("found block spawns", xs)

	if not block_scene:
		return

	for x in xs:
		var new_block = block_scene.instance()
		new_block.position = x.position
		call_deferred("add_child", new_block)

func _on_player_entered(_player):
	spawn_blocks()

	runs = runs + 1

func is_finished():
	return runs >= max_runs


func _on_player_exited(_player):
	for block in Util.get_children_in_group(self, "block"):
		block.queue_free()
