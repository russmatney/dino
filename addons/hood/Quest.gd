extends Node

signal all_quests_complete
signal quest_update

var active_quests = {}

func q_label(node, opts):
	return opts.get("label", node.name)

func register_quest(node, opts={}):
	var label = q_label(node, opts)
	if label in active_quests:
		print("[WARN]: skipping register of existing quest with node.label: ", label)
		return

	Util.ensure_connection(node, "quest_complete", self, "_on_complete", [node, opts])

	var quest = ActiveQuest.new()
	quest.label = label
	quest.node = node
	active_quests[label] = quest

	Hood.notif(str("Registered Quest: ", label))
	emit_signal("quest_update")

func flash_quest_status():
	# TODO briefly show quest status
	pass

func _on_complete(node, opts):
	var label = q_label(node, opts)
	active_quests[label].complete = true

	# TODO juicy UI banner
	# TODO animate in/out updated quest 'sheet'

	emit_signal("quest_update")

	var incomplete = []
	for q in active_quests.values():
		if not q.complete:
			incomplete.append(q)
			break
	if not incomplete:
		Hood.notif("All quests complete!")
		emit_signal("all_quests_complete")
