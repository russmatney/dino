extends Node
class_name Quest

## has_required ###########################################

func has_required_entities(entities: Array[Node]):
	if xs_group == "":
		Log.warn("No xs_group, fallback has_required_entities pred returning false")
		return false
	for e in entities:
		if e.is_in_group(xs_group):
			return true
	return false

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

func to_printable():
	return {label=label, total=total, xs_group=xs_group}

## enter tree ##########################################################

func _enter_tree():
	add_to_group("quests", true)

	if not has_method("setup"):
		Log.warn("Quest missing expected setup() method", self)
	if not has_method("update_quest"):
		Log.warn("Quest missing expected update_quest() method", self)

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
	total = len(xs)
	for x in xs:
		# does this get called/fired multiple times?
		U._connect(x_update_signal.call(x), update_quest)

	update_quest()

## update ##############################################################################

# support an optional arg so various update signal impls can land here
func update_quest(_x=null):
	# side-notif?
	# Log.info("quest updated!", _x, self)
	count_total_update.emit(total)

	var remaining = len(get_xs.call().filter(is_remaining))
	count_remaining_update.emit(remaining)

	if has_method("on_quest_update"):
		self["on_quest_update"].call({total=total, remaining=remaining})

	if remaining == 0 and total > 0:
		quest_complete.emit()
		Dino.notif({
			type="side",
			text="%s complete!" % label,
			})
