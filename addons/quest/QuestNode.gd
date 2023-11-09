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

## exit tree ##########################################################

func _exit_tree():
	if Engine.is_editor_hint():
		return
	Q.unregister(self)
