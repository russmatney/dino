extends Quest
class_name QuestFeedTheVoid

## vars ##############################################################################

var total = 0

## ready ##########################################################

func _ready():
	label = "Feed The Voids"

## setup ##############################################################################

func setup():
	var xs = get_voids()
	total = len(xs)
	for v in xs:
		U._connect(v.void_satisfied, func(): update_quest())

	update_quest()

## get_voids ##############################################################################

func get_voids() -> Array:
	if is_inside_tree():
		return get_tree().get_nodes_in_group("voids")
	return []

## update ##############################################################################

func update_quest():
	Log.pr("feed the voids update_quest")
	count_total_update.emit(total)

	var remaining = get_voids().filter(func(v): return not v.complete)
	count_remaining_update.emit(len(remaining))

	if len(remaining) == 0 and total > 0:
		quest_complete.emit()
