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
	Blocks.ensure_blocks(self)

func cleanup():
	.cleanup()

	# pause, then remove blocks
	yield(get_tree().create_timer(0.4), "timeout")
	Blocks.cleanup_blocks(self)

func _on_player_entered(_player):
	Blocks.ensure_blocks(self)
	runs = runs + 1

	print("[NOTIF] player entered KnockEm")

func is_finished():
	var blocks_remaining = Blocks.get_blocks(self)

	if not blocks_remaining:
		print("no more blocks? finished?")
		# return true

	return runs >= max_runs

func _on_player_exited(_player):
	print(max_runs - runs, " attempts remain")
	pass
