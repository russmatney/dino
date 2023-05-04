class_name ActiveQuest
extends Node

var label: String
var complete: bool = false
var failed: bool = false
var node: Node

var remaining: int
var total: int
var optional: bool
var check_not_failed: bool

func _to_string():
	return Debug.to_pretty({
		label=label,
		complete=complete,
		failed=failed,
		node=node,
		remaining=remaining,
		total=total,
		optional=optional,
		check_not_failed=check_not_failed,
		})
