extends Quest
class_name FetchSheepQuest

## vars ##########################################################

var all_sheep = []
var penned_sheep = []

## ready ##########################################################

func _ready():
	label = "Fetch all the sheep!"

## setup ##########################################################

func setup():
	var level_root = U.find_level_root(self)
	Log.pr("looking for sheep in level_root", level_root)
	all_sheep = U.get_children_in_group(level_root, "sheep")

	if len(all_sheep) == 0:
		Log.error("FetchSheepQuest found zero sheep")
		return

	for s in all_sheep:
		s.dying.connect(sheep_died)

	var found_pen = false
	for p in U.get_children_in_group(level_root, "pen"):
		if p is Area2D:
			p.body_entered.connect(on_body_entered)
			p.body_exited.connect(on_body_exited)
			found_pen = true
	if not found_pen:
		Log.error("FetchSheepQuest found no 'pen' Area2Ds")
		return

	update_quest()

## sheep/pen signals ##########################################################

func on_body_entered(body):
	Log.pr("body entered pen", body)
	if body in all_sheep and body not in penned_sheep:
		penned_sheep.append(body)
		update_quest()

func on_body_exited(body):
	penned_sheep.erase(body)
	update_quest()

func sheep_died(s):
	all_sheep.erase(s)
	update_quest()

## quest update ##########################################################

func update_quest(_x=null):
	var remaining = all_sheep.filter(func(s): return not s in penned_sheep)

	count_remaining_update.emit(len(remaining))
	count_total_update.emit(len(all_sheep))

	if len(remaining) == 0 and len(all_sheep) > 0:
		quest_complete.emit()

	if len(all_sheep) == 0:
		# presumably, all the sheep died
		quest_failed.emit()
