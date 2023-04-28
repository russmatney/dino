extends Node2D


func _ready():
	var _x = Hood.found_player.connect(setup)
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
	if not is_instance_valid(p):
		return
	player = p
	player.highlight.call_deferred("Clear The Grid!")
	Hood.notif("Clear the Grid!")

	if player.grid:
		find_remaining_cells()
		count_total_update.emit(count_remaining)

	Util._connect(player.grid.cell_touched, _on_cell_touched)

func find_remaining_cells():
	count_remaining = player.grid.untouched_cells().size()
	count_remaining_update.emit(count_remaining)

func _on_cell_touched(_coord):
	find_remaining_cells()

	if count_remaining <= 0:
		Hood.notif("Grid Cleared!")
		quest_complete.emit()
	else:
		pass
	# TODO highlight this via Hood
		# player.highlight("--cells remaining")
		# Hood.notif(str("remaining cells: ", count_remaining))
