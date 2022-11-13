tool
extends RunnerRoom

var max_runs = 6
var runs = 0

func _ready():
	Util.ensure_connection(self, "player_entered", self, "_on_player_entered")
	Util.ensure_connection(self, "player_exited", self, "_on_player_exited")

	setup()

	if Engine.editor_hint:
		request_ready()

func setup():
	.setup()
	ensure_blocks()

func cleanup():
	.cleanup()

	# pause, then remove blocks
	yield(get_tree().create_timer(0.4), "timeout")
	for block in Util.get_children_in_group(self, "block"):
		block.queue_free()

onready var block_scene = preload("res://src/runner/gravity/Block.tscn")

func ensure_blocks():
	var existing_blocks = Util.get_children_in_group(self, "block")
	if existing_blocks:
		return

	var xs = Util.get_children_in_group(self, "block_spawn")

	if not block_scene:
		return

	for x in xs:
		var new_block = block_scene.instance()
		new_block.position = x.position
		call_deferred("add_child", new_block)

func _on_player_entered(_player):
	ensure_blocks()

	runs = runs + 1

func is_finished():
	return runs >= max_runs


func _on_player_exited(_player):
	pass
