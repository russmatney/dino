extends Node

var active_quests = {}

func q_label(node, opts):
	return opts.get("label", node.label)

func register_quest(node, opts={}):
	var label = q_label(node, opts)
	if active_quests[label]:
		print("[WARN]: skipping register of existing quest with node.label: ", label)
		return

	Util.ensure_connection(node, "quest_complete", self, "_on_complete", [node, opts])

	var quest = ActiveQuest.new()
	quest.label = label
	quest.node = node
	active_quests.append(quest)

	Hood.notify("Registered Quest: ", label)

func flash_quest_status():
	# TODO briefly show quest status
	pass

signal all_quests_complete

func _on_complete(node, opts):
	var label = q_label(node, opts)
	active_quests[label].complete = true

	# TODO juicy UI banner
	# TODO animate in/out updated quest 'sheet'

	var incomplete = []
	for q in active_quests.values():
		if not q.complete:
			incomplete.append(q)
			break
	if not incomplete:
		Hood.notify("All quests complete!")
		emit_signal("all_quests_complete")
