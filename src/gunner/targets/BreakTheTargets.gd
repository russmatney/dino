extends Quest

## vars ##############################################################################

var total = 0

## ready ##########################################################

func _ready():
	label = "Break The Targets"

## setup ##############################################################################

func setup():
	var targets = get_targets()
	total = len(targets)
	for t in targets:
		Util._connect(t.tree_exited, update_quest)

	update_quest()

## get_targets ##############################################################################

func get_targets():
	var t = get_tree()
	if t:
		return get_tree().get_nodes_in_group("target")

## update ##############################################################################

func update_quest():
	count_total_update.emit(total)

	var remaining = get_targets()
	count_remaining_update.emit(len(remaining))

	if len(remaining) == 0 and total > 0:
		quest_complete.emit()
