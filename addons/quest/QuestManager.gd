extends Node
# TODO move to Quest Manager that creates a node, rather than a global quest singleton

## vars #####################################################

signal all_quests_complete
signal quest_failed
signal quest_update

var active_quests = {}

var current_level_label = "Quest Status"

## label #####################################################

func q_label(node, opts):
	var label = node.get("label")
	if label in [null, ""]:
		label = opts.get("label", "Fallback Label")
	return str("%s-%s" % [label, node.name])

func get_quest(node, opts={}):
	return active_quests.get(q_label(node, opts))

## register quest and updates #####################################################

func setup_quests():
	for q in active_quests.values():
		q.queue_free()

	active_quests = {}
	for q in get_tree().get_nodes_in_group("quests"):
		register_quest(q)
	for q in active_quests.values():
		q.node.setup()

func drop_quests():
	for q in active_quests.values():
		q.queue_free()
	active_quests = {}

func register_quest(node, opts={}):
	if node == null:
		Log.warn("passed quest is null, skipping", node, opts)
		return
	var label = q_label(node, opts)
	if label in active_quests:
		Log.warn("OVERWRITING existing quest with node.label:", label)

	U._connect(node.quest_complete, _on_complete.bind(node, opts))
	U._connect(node.quest_failed, _on_fail.bind(node, opts))
	U._connect(node.count_remaining_update, _on_count_remaining_update.bind(node, opts))
	U._connect(node.count_total_update, _on_count_total_update.bind(node, opts))

	# TODO rename QuestData?
	var quest = QuestData.new()
	quest.label = node.label
	quest.node = node
	quest.optional = opts.get("optional", false)
	quest.check_not_failed = opts.get("check_not_failed", false)
	active_quests[label] = quest

	Log.pr(str("Registered Quest: ", label))
	quest_update.emit()

func unregister(node, opts={}):
	var label = q_label(node, opts)
	active_quests.erase(label)
	quest_update.emit()

## all complete? #####################################################

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
	Log.pr("All quests complete!")
	all_quests_complete.emit()

## signal updates #####################################################

func _on_complete(node, opts):
	var label = q_label(node, opts)
	Log.pr("Quest complete!", label)
	var q = get_quest(node, opts)
	if q:
		q.complete = true

	quest_update.emit()
	check_all_complete()

func _on_fail(node, opts):
	var q = get_quest(node, opts)
	if q:
		q.failed = true
		quest_failed.emit(q)
	quest_update.emit()

func _on_count_total_update(total, node, opts):
	var q = get_quest(node, opts)
	if q:
		q.total = total
	quest_update.emit()

func _on_count_remaining_update(remaining, node, opts):
	var q = get_quest(node, opts)
	if q:
		q.remaining = remaining
	quest_update.emit()
