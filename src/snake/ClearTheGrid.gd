extends Node2D


func _ready():
	var _x = Hood.connect("found_player", self, "setup")
	if Hood.player:
		setup(Hood.player)

var player
var remaining_cell_count

func setup(p):
	player = p
	player.call_deferred("highlight", "Clear The Grid!")
	Hood.notif("Clear the Grid!")

	if player.grid:
		remaining_cell_count = player.grid.untouched_cells().size()


	Util.ensure_connection(player.grid, "cell_touched", self, "_on_cell_touched")

func _on_cell_touched(_coord):
	remaining_cell_count = player.grid.untouched_cells().size()

	if remaining_cell_count <= 0:
		Hood.notif("Grid Cleared!")
	else:
		pass
	# TODO this highlight via Hood
		# player.highlight("--cells remaining")
		# Hood.notif(str("remaining cells: ", remaining_cell_count))
