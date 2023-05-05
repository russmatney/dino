extends Node

signal all_quests_complete
signal quest_failed
signal quest_update

func _ready():
	ensure_jumbotron()

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
		Debug.warn("OVERWRITING existing quest with node.label:", label)

	if node.has_signal("quest_complete"):
		node.quest_complete.connect(_on_complete.bind(node, opts))
	if node.has_signal("quest_failed"):
		node.quest_failed.connect(_on_fail.bind(node, opts))
	if node.has_signal("count_remaining_update"):
		node.count_remaining_update.connect(_on_count_remaining_update.bind(node, opts))
	if node.has_signal("count_total_update"):
		node.count_total_update.connect(_on_count_total_update.bind(node, opts))

	var quest = ActiveQuest.new()
	quest.label = label
	quest.node = node
	quest.optional = opts.get("optional", false)
	quest.check_not_failed = opts.get("check_not_failed", false)
	active_quests[label] = quest

	Debug.pr(str("Registered Quest: ", label))
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
	Debug.pr("All quests complete!")
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

###########################################################################
# jumbotron

var jumbotron_scene = preload("res://addons/quest/Jumbotron.tscn")
var jumbotron

func ensure_jumbotron():
	if jumbotron and is_instance_valid(jumbotron):
		return

	jumbotron = jumbotron_scene.instantiate()
	jumbotron.set_visible(false)
	Navi.add_child(jumbotron)

signal jumbo_closed

func jumbo_notif(opts):
	if not jumbotron or not is_instance_valid(jumbotron):
		Debug.err("No valid jumbotron, cannot present jumbo_notif", opts)
		return

	var body = opts.get("body")
	var key_or_action = opts.get("key")
	key_or_action = opts.get("action", key_or_action)
	var action_label_text = opts.get("action_label_text")
	var header = opts.get("header")
	var on_close = opts.get("on_close")

	jumbotron.header_text = header
	if body:
		jumbotron.body_text = body
	else:
		jumbotron.body_text = ""
	if key_or_action or action_label_text:
		jumbotron.action_hint.display(key_or_action, action_label_text)
	else:
		jumbotron.action_hint.hide()

	if on_close:
		jumbo_closed.connect(on_close, ConnectFlags.CONNECT_ONE_SHOT)

	# pause game?
	jumbotron.fade_in()

	return jumbo_closed
