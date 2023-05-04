@tool
extends Node

@onready var sheep_pen = $SheepPen

var all_sheep = []

signal quest_complete
signal quest_failed
signal count_remaining_update
signal count_total_update

###########################################################
# config warning

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=["SheepPen"]})

###########################################################
# ready

func _ready():
	if not sheep_pen:
		Debug.error("FetchSheepQuest expected $SheepPen Area2D to exist")
		return

	sheep_pen.body_entered.connect(on_body_entered)
	sheep_pen.body_exited.connect(on_body_exited)

	Quest.register_quest(self, {label="Fetch all the sheep!"})

	all_sheep = get_tree().get_nodes_in_group("sheep")

	if len(all_sheep) == 0:
		Debug.error("FetchSheepQuest found zero sheep")
		return

	for s in all_sheep:
		s.dying.connect(sheep_died)

	update_quest()

###########################################################
# exit tree

func _exit_tree():
	Quest.unregister(self)

###########################################################
# quest update

func update_quest():
	var remaining = all_sheep.filter(func(s): return not s in penned_sheep)

	# TODO feels like we should update these at the same time, maybe with one emit or Quests fn call
	count_remaining_update.emit(len(remaining))
	count_total_update.emit(len(all_sheep))

	if len(remaining) == 0 and len(all_sheep) > 0:
		quest_complete.emit()

	if len(all_sheep) == 0:
		# presumably, all the sheep died
		quest_failed.emit()

	Debug.pr(Quest.active_quests)

###########################################################
# sheep death

func sheep_died(s):
	all_sheep.erase(s)
	update_quest()

###########################################################
# sheep returned

var penned_sheep = []
func on_body_entered(body):
	if body in all_sheep and body not in penned_sheep:
		penned_sheep.append(body)
		update_quest()

func on_body_exited(body):
	penned_sheep.erase(body)
	update_quest()
