@tool
extends RunnerRoom

var max_runs = 3
var runs = 0


func _ready():
	Util.ensure_connection(self, "player_entered", self, "_on_player_entered")
	Util.ensure_connection(self, "player_exited", self, "_on_player_exited")

	setup()

	if Engine.is_editor_hint():
		request_ready()


func setup():
	super.setup()
	Blocks.ensure_blocks(self)


func cleanup():
	super.cleanup()

	# pause, then remove_at blocks
	await get_tree().create_timer(0.4).timeout
	Blocks.cleanup_blocks(self)


func _on_player_entered(p):
	Blocks.ensure_blocks(self)
	runs = runs + 1

	Debug.pr("[NOTIF] player entered KnockEm")

	if p:
		p.destroy_blocks = true

	# TODO player touches block to enable it
	# TODO once touched, blocks outside of some square are 'complete'
	# TODO block-spawners track their block, to know when they're done/destroyed?
	# Blocks need to track and destory their parent spawn point


func is_finished():
	var blocks_remaining = Blocks.get_blocks(self)

	# no more blocks, or no more runs
	return not blocks_remaining or runs >= max_runs


func _on_player_exited(p):
	Debug.pr(max_runs - runs, " attempts remain")

	p.destroy_blocks = false
