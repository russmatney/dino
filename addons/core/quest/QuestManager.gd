extends Node
class_name QuestManager

## static #####################################################

static var quests = {
	QuestFeedTheVoid: {},
	QuestBreakTheTargets: {},
	QuestCatchLeaves: {},
	QuestCollectGems: {},
	QuestKillAllEnemies: {},
	FetchSheepQuest: {},
	# TODO harvey quests
	"QuestDeliverProduceCarrot": {new=func(): return QuestDeliverProduce.new({type="carrot"})},
	"QuestDeliverProduceOnion": {new=func(): return QuestDeliverProduce.new({type="tomato"})},
	"QuestDeliverProduceTomato": {new=func(): return QuestDeliverProduce.new({type="onion"})},
	}

static func quest_insts():
	var qs = []
	for q_class in quests:
		var opts = quests.get(q_class, {})
		var q
		if opts.get("new"):
			q = opts.get("new").call()
		else:
			q = q_class.new()
		qs.append(q)
	return qs

# TODO this is messy, plz refactor
# maybe quest_manager has an exported lists of quests to check?
# defaulting to _all_
static func quests_for_nodes(nodes: Array[Node]):
	var qs = []
	for q in quest_insts():
		if q.has_required_nodes(nodes):
			# TODO search/dedupe existing quests?
			qs.append(q)
		else:
			q.queue_free()
	return qs

static func quests_for_entities(entities):
	var qs = []
	for q in quest_insts():
		if q.has_required_entities(entities):
			qs.append(q)
	return qs

## vars #####################################################

signal all_quests_completed
signal quest_failed
signal quest_update
signal quest_complete(quest)

@export var manual_mode = false

var active_quests = {}

## enter tree #####################################################

func _enter_tree():
	get_tree().node_added.connect(on_node_added)
	get_tree().node_removed.connect(on_node_removed)

func on_node_added(node: Node):
	if manual_mode:
		return
	if len(node.get_groups()) > 0:
		# impl rn now is stupidly expensive
		add_quests_for_nodes([node])

func on_node_removed(node: Node):
	if manual_mode:
		return
	if node is Quest:
		# is node ready here?
		# TODO sometimes quests unregister w/ opts?
		unregister(node)

func add_quests_for_nodes(nodes: Array[Node]):
	var qs = QuestManager.quests_for_nodes(nodes)
	for q in qs:
		var existing = get_quest(q)
		if not existing:
			add_child(q)
			register_quest(q)

func add_quests_for_entities(ents):
	var qs = QuestManager.quests_for_entities(ents)
	for q in qs:
		q.setup_with_entities(ents)
		var existing = get_quest(q)
		if not existing:
			add_child(q)
			register_quest(q)

## ready #####################################################

func _ready():
	if manual_mode:
		return
	# check for quests based on existing nodes (added before the manager)
	var ents = U.get_all_children(get_parent()).filter(func(ent): return len(ent.get_groups()) > 0)
	var _ents: Array[Node] = []
	_ents.assign(ents)
	add_quests_for_nodes(_ents)

## label #####################################################

func q_label(node, opts):
	# TODO node still valid at exit time?
	var label = node.get("label")
	if label in [null, ""]:
		label = opts.get("label", "Fallback Label")
	# return "%s-%s" % [label, node.name]
	return "%s" % label

func get_quest(node, opts={}):
	return active_quests.get(q_label(node, opts))

## register quest and updates #####################################################

func drop_quests():
	for q in active_quests.values():
		remove_child(q)
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
	quest.check_not_failed = opts.get("check_not_failed", false)
	active_quests[label] = quest

	# Log.info("Registered Quest", quest)
	quest_update.emit()

func unregister(node, opts={}):
	var label = q_label(node, opts)
	active_quests.erase(label)
	quest_update.emit()

## all complete? #####################################################

func all_quests_complete() -> bool:
	var incomplete = []
	var check_not_failed = []
	for q in active_quests.values():
		if not q.complete:
			if q.check_not_failed:
				check_not_failed.append(q)
			else:
				incomplete.append(q)
				break

	if not incomplete.is_empty():
		return false

	if check_not_failed:
		for q in check_not_failed:
			if q.failed:
				return false

	return true

func check_all_complete():
	if all_quests_complete():
		# all complete and/or not-failed!
		Log.info("All quests complete!")
		all_quests_completed.emit()

## signal updates #####################################################

func _on_complete(node, opts):
	var label = q_label(node, opts)
	# Log.info("Quest complete!", node)
	var q = get_quest(node, opts)
	if q:
		q.complete = true

	quest_update.emit()
	quest_complete.emit(q)
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
