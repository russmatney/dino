extends Quest

## vars ##############################################################################

var total = 0

## ready ##########################################################

func _ready():
	label = "Catch The Leaves"

## setup ##############################################################################

func setup():
	var xs = get_leaves()
	total = len(xs)
	for l in xs:
		U._connect(l.caught, func(): update_quest())

	update_quest()

## get_leaves ##############################################################################

func get_leaves() -> Array:
	if is_inside_tree():
		return get_tree().get_nodes_in_group("leaves")
	return []

## update ##############################################################################

func update_quest():
	count_total_update.emit(total)

	var remaining = get_leaves().filter(func(l): return not l.is_caught)
	count_remaining_update.emit(len(remaining))

	if len(remaining) == 0 and total > 0:
		quest_complete.emit()
