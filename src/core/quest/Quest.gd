extends Node
class_name Quest

## ents and setup ###########################################

# for more involved quests, these need to be overwritten

func has_required_nodes(nodes: Array[Node]):
	if xs_group == "":
		Log.warn("No xs_group, fallback has_required_nodes pred returning false")
		return false
	for n in nodes:
		if n.is_in_group(xs_group):
			return true
	return false

func has_required_entities(ents):
	for e in ents:
		var e_id = e.get_entity_id()
		if e_id in entity_ids:
			# any ents vs all ents required?
			return true
	return false

func setup_with_entities(ents):
	var relevant_ents = []
	for e in ents:
		var e_id = e.get_entity_id()
		if e_id in entity_ids:
			relevant_ents.append(e)

	manual_total = len(relevant_ents)

## vars ##########################################################

signal quest_complete
signal quest_failed
signal count_remaining_update
signal count_total_update


var total = 0
var label
var xs_group = ""
var get_xs = func():
	if is_inside_tree():
		return get_tree().get_nodes_in_group(xs_group)
	return []
var x_update_signal = func(x): return null
var is_remaining = func(x): return true

var entity_ids = []

# override the observed/auto-calced 'total'
var manual_total

func to_pretty():
	return {label=label, total=total, manual_total=manual_total, xs_group=xs_group, xs_updated=len(xs_updated)}

## enter tree ##########################################################

func _enter_tree():
	add_to_group("quests", true)

	if not Engine.is_editor_hint():
		get_tree().node_added.connect(on_node_added)

func on_node_added(node: Node):
	if node.is_in_group(xs_group):
		# too big a hammer?
		setup()

## ready ##############################################################################

func _ready():
	setup()

	Dino.notif({
		type="side",
		text="New Quest: %s" % label,
		})

## setup ##############################################################################

# rename 'reset data?'
func setup():
	var xs = get_xs.call()
	if manual_total != null:
		total = manual_total
	else:
		total = len(xs)

	for x in xs:
		# does this get called/fired multiple times?
		U._connect(x_update_signal.call(x), update_quest)

	update_quest()

## update ##############################################################################

# support an optional arg so various update signal impls can land here
var xs_updated = []
func update_quest(x=null):
	# side-notif?
	# Log.info("quest updated!", _x, self)
	count_total_update.emit(total)

	var remaining = len(get_xs.call().filter(is_remaining))
	count_remaining_update.emit(remaining)

	if manual_total != null:
		if x == null:
			Log.warn("quest updated with null x", self)
			return
		# perhaps this is a better quest update method
		# i think we can count on uniqueness here, tho these xs might be dropped/freed :/
		if not x in xs_updated:
			xs_updated.append(x)
		if len(xs_updated) == manual_total:
			quest_complete.emit()
	elif remaining == 0 and total > 0:
		quest_complete.emit()
		Dino.notif({
			type="side",
			text="%s complete!" % label,
			})
