extends Quest

## vars ##########################################################

var total

## ready ##########################################################

func _ready():
	label = "Collect All Gems"
	setup()

## setup ##########################################################

func setup():
	set_total()
	for g in get_gems():
		g.tree_exited.connect(update_quest)
	update_quest()

func set_total():
	total = len(get_gems())

## getter ##########################################################

func get_gems():
	return get_tree().get_nodes_in_group("gems")

## update ##########################################################

func update_quest():
	count_total_update.emit(total)
	var remaining = get_gems()
	count_remaining_update.emit(len(remaining))

	if len(remaining) == 0 and total > 0:
		quest_complete.emit()
