extends Quest

## vars ##########################################################

var total

## ready ##########################################################

func _ready():
	label = "Collect All Gems"

## setup ##########################################################

func setup():
	set_total()
	for g in get_gems():
		Util._connect(g.tree_exited, update_quest)
	update_quest()

func set_total():
	total = len(get_gems())

## getter ##########################################################

func get_gems():
	var t = get_tree()
	if t:
		return t.get_nodes_in_group("gems")

## update ##########################################################

func update_quest():
	count_total_update.emit(total)
	var remaining = get_gems()
	count_remaining_update.emit(len(remaining))

	if len(remaining) == 0 and total > 0:
		quest_complete.emit()
