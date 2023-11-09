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
		Debug.pr("connecting to gem tree_exit")
		Util._connect(g.tree_exited, update_quest)
	update_quest()

func set_total():
	var g = get_gems()
	if g:
		total = len(g)

## getter ##########################################################

func get_gems():
	var t = get_tree()
	if t:
		return t.get_nodes_in_group("gems")

## update ##########################################################

func update_quest():
	Debug.pr("gem exited tree")
	count_total_update.emit(total)
	var remaining = get_gems()
	if remaining:
		count_remaining_update.emit(len(remaining))

		if len(remaining) == 0 and total > 0:
			quest_complete.emit()
