extends Quest
class_name FetchSheepQuest

var has_sheep = false
var has_pen = false

func has_required_nodes(nodes: Array[Node]):
	for n in nodes:
		if n.is_in_group("sheep"):
			has_sheep = true
			break
		if n.is_in_group("pen"):
			has_pen = true
			break
	return has_sheep or has_pen

## vars ##########################################################

var penned_sheep = []

signal sheep_pen_update(sheep)

## ready ##########################################################

func _init():
	label = "Fetch all the sheep!"
	xs_group = "sheep"
	is_remaining = func(x):
		return not x.is_dead and not x in penned_sheep

## setup ##########################################################

func setup():
	var level_root = U.find_level_root(self)

	var found_pen
	for p in U.get_children_in_group(level_root, "pen"):
		if p is Area2D:
			p.body_entered.connect(on_body_entered)
			p.body_exited.connect(on_body_exited)
			found_pen = true
	if not found_pen:
		Log.warn("Could not find pen for fetch sheep quest")

	super.setup()

## sheep/pen signals ##########################################################

func on_body_entered(body):
	if body.is_in_group("sheep") and body not in penned_sheep:
		penned_sheep.append(body)
		update_quest()

func on_body_exited(body):
	if body.is_in_group("sheep"):
		penned_sheep.erase(body)
		update_quest()
