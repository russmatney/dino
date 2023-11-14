extends Node
class_name Quest

## vars ##########################################################

signal quest_complete
signal quest_failed
signal count_remaining_update
signal count_total_update

var label

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
