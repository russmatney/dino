class_name QuestData
extends Node

var label: String
var complete: bool = false
var failed: bool = false
var node: Node

var remaining: int
var total: int
var check_not_failed: bool

func to_pretty():
	return {
		label=label,
		complete=complete,
		failed=failed,
		node=node,
		remaining=remaining,
		total=total,
		check_not_failed=check_not_failed,
	}

func _to_string():
	return Log.to_pretty(self)
