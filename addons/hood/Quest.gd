extends Node

signal all_quests_complete
signal quest_failed
signal quest_update

######################################################
# data

var active_quests = {}

func q_label(node, opts):
	return opts.get("label", node.name)

var current_level_label = "Quest Status"

######################################################
# register quest and updates

func register_quest(node, opts={}):
	var label = q_label(node, opts)
	if label in active_quests:
		Debug.warn("skipping register of existing quest with node.label:", label)
		return

	if node.has_signal("quest_complete"):
		Util.ensure_connection(node, "quest_complete", self, "_on_complete", [node, opts])
	if node.has_signal("quest_failed"):
		Util.ensure_connection(node, "quest_failed", self, "_on_fail", [node, opts])
	if node.has_signal("count_remaining_update"):
		Util.ensure_connection(node, "count_remaining_update", self, "_on_count_remaining_update", [node, opts])
	if node.has_signal("count_total_update"):
		Util.ensure_connection(node, "count_total_update", self, "_on_count_total_update", [node, opts])

	var quest = ActiveQuest.new()
	quest.label = label
	quest.node = node
	quest.optional = opts.get("optional", false)
	quest.check_not_failed = opts.get("check_not_failed", false)
	active_quests[label] = quest

	Hood.notif(str("Registered Quest: ", label))
	quest_update.emit()

func unregister(node, opts={}):
	var label = q_label(node, opts)
	active_quests.erase(label)
	quest_update.emit()


######################################################
# public helper

func flash_quest_status():
	# TODO briefly show quest status
	pass

######################################################
# all complete?

func check_all_complete():
	var incomplete = []
	var check_not_failed = []
	for q in active_quests.values():
		if not q.complete:
			if q.check_not_failed:
				check_not_failed.append(q)
			else:
				incomplete.append(q)
				break
	if incomplete:
		return

	if check_not_failed:
		for q in check_not_failed:
			if q.failed:
				return

	# all complete or not failed!
	Hood.notif("All quests complete!")
	all_quests_complete.emit()

######################################################
# signal updates


func _on_complete(node, opts):
	var label = q_label(node, opts)
	active_quests[label].complete = true

	quest_update.emit()
	check_all_complete()

func _on_fail(node, opts):
	var label = q_label(node, opts)
	active_quests[label].failed = true
	quest_update.emit()
	quest_failed.emit(active_quests[label])

func _on_count_total_update(total, node, opts):
	var label = q_label(node, opts)
	active_quests[label].total = total
	quest_update.emit()

func _on_count_remaining_update(remaining, node, opts):
	var label = q_label(node, opts)
	active_quests[label].remaining = remaining
	quest_update.emit()
