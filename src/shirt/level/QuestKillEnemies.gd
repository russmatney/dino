extends Quest

## ready ##########################################################

func _ready():
	label = "Kill All Enemies"

## setup ##########################################################

func setup():
	for e in get_enemies():
		U._connect(e.died, update_quest)
	update_quest()

## getter ##########################################################

func get_enemies() -> Array:
	var t = get_tree()
	if t:
		return t.get_nodes_in_group("enemies")
	return []

## update ##########################################################

func update_quest():
	if not is_inside_tree():
		return
	var enemies = get_enemies()
	count_total_update.emit(len(enemies))

	var remaining = enemies.filter(func(e): return not e.is_dead)
	count_remaining_update.emit(len(remaining))

	if len(remaining) == 0 and len(enemies) > 0:
		quest_complete.emit()
