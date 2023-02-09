extends Node2D


func _ready():
	var _x = Hood.connect("found_player",Callable(self,"setup"))
	if Hood.player and is_instance_valid(Hood.player):
		setup(Hood.player)

	Quest.register_quest(self)

func _exit_tree():
	Quest.unregister(self)

signal quest_complete
# signal quest_failed
signal count_remaining_update
signal count_total_update

var player
var count_remaining

func setup(p):
	player = p
	player.call_deferred("highlight", "Clear The Grid!")
	Hood.notif("Clear the Grid!")

	if player.grid:
		find_remaining_cells()
		emit_signal("count_total_update", count_remaining)


	Util.ensure_connection(player.grid, "cell_touched", self, "_on_cell_touched")

func find_remaining_cells():
	count_remaining = player.grid.untouched_cells().size()
	emit_signal("count_remaining_update", count_remaining)

func _on_cell_touched(_coord):
	find_remaining_cells()

	if count_remaining <= 0:
		Hood.notif("Grid Cleared!")
		emit_signal("quest_complete")
	else:
		pass
	# TODO highlight this via Hood
		# player.highlight("--cells remaining")
		# Hood.notif(str("remaining cells: ", count_remaining))
