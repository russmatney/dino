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

# TODO this is messy, plz refactor
# maybe quest_manager has an exported lists of quests to check?
# defaulting to _all_
static func quests_for_entities(entities: Array[Node]):
	var qs = []
	for q_class in quests:
		var opts = quests.get(q_class, {})
		var q
		if opts.get("new"):
			q = opts.get("new").call()
		else:
			q = q_class.new()

		if q.has_required_entities(entities):
			qs.append(q)
		else:
			q.queue_free()
	return qs

## vars #####################################################

signal all_quests_complete
signal quest_failed
signal quest_update

var active_quests = {}

## enter tree #####################################################

func _enter_tree():
	get_tree().node_added.connect(on_node_added)
	get_tree().node_removed.connect(on_node_removed)

func check_quests_for_node(node: Node):
	var qs = QuestManager.quests_for_entities([node])
	for q in qs:
		var existing = get_quest(q)
		if not existing:
			add_child(q)
		var q_data = get_quest(q)
		if not q_data:
			Log.warn("Expected quest to be added for node", q, node)
			continue
		# hmmm - here have data.node instead of node.data
		q_data.node.add_entity(node)

func on_node_added(node: Node):
	if node is Quest:
		# is node ready here?
		# TODO sometimes quests register w/ opts?
		register_quest(node)
		# TODO prefer this call in Quest.ready?
		node.setup()
	else:
		# impl rn now i stupidly expensive
		check_quests_for_node(node)

func on_node_removed(node: Node):
	if node is Quest:
		# is node ready here?
		# TODO sometimes quests unregister w/ opts?
		unregister(node)

## ready #####################################################

func _ready():
	Log.pr("quest manager _ready()")

	setup_quests()


## label #####################################################

func q_label(node, opts):
	# TODO node still valid?
	var label = node.get("label")
	if label in [null, ""]:
		label = opts.get("label", "Fallback Label")
	return str("%s-%s" % [label, node.name])

func get_quest(node, opts={}):
	return active_quests.get(q_label(node, opts))

## register quest and updates #####################################################

func setup_quests():
	for q in get_tree().get_nodes_in_group("quests"):
		register_quest(q)
	for q in active_quests.values():
		q.node.setup()

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
	quest.optional = opts.get("optional", false)
	quest.check_not_failed = opts.get("check_not_failed", false)
	active_quests[label] = quest

	Log.pr(str("Registered Quest: ", quest))
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
	Log.pr("Quest complete!", node)
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
