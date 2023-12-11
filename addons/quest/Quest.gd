extends Node
class_name Quest

## vars ##########################################################

signal quest_complete
signal quest_failed
signal count_remaining_update
signal count_total_update

var total = 0
var label
var get_xs_group = ""
var get_xs = func():
	if is_inside_tree():
		return get_tree().get_nodes_in_group(get_xs_group)
	return []
var x_update_signal = func(x): return null
var is_remaining = func(x): return true

## enter tree ##########################################################

func _enter_tree():
	add_to_group("quests", true)

	if not has_method("setup"):
		Log.warn("Quest missing expected setup() method", self)
	if not has_method("update_quest"):
		Log.warn("Quest missing expected update_quest() method", self)

## exit tree ##########################################################

func _exit_tree():
	if Engine.is_editor_hint():
		return
	Q.unregister(self)

## setup ##############################################################################

func setup():
	var xs = get_xs.call()
	total = len(xs)
	for x in xs:
		U._connect(x_update_signal.call(x), update_quest)

	update_quest()


## update ##############################################################################

# support an optional arg so various update signal impls can land here
func update_quest(_x=null):
	count_total_update.emit(total)

	var remaining = len(get_xs.call().filter(is_remaining))
	count_remaining_update.emit(remaining)

	if has_method("on_quest_update"):
		self["on_quest_update"].call({total=total, remaining=remaining})

	if remaining == 0 and total > 0:
		quest_complete.emit()
