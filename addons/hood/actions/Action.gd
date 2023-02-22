@tool
class_name Action
extends Object

var fn: Callable
var label: String
var key: String
var source: Node
var source_can_execute: Callable = func(): return true
var actor_could_execute: Callable = func(_a): return true

func _to_string():
	if source:
		return "Action: %s on source: %s" % [label, source]
	else:
		return "Action: %s" % label

static func mk(opts) -> Action:
	var ax = Action.new()
	ax.label = opts.get("label", "Action")
	ax.fn = opts.get("fn", func(): print("No-op action"))
	ax.source_can_execute = opts.get("source_can_execute", func(): return true)
	ax.actor_could_execute = opts.get("actor_could_execute", func(_a): return true)
	return ax

func can_execute_now(actor) -> bool:
	return could_execute(actor) and close_enough_to_execute(actor)

func could_execute(actor) -> bool:
	return source_can_execute.call() and actor_could_execute.call(actor)

func close_enough_to_execute(_actor) -> bool:
	# TODO is actor body in action_area bodies?
	return true

# TODO args
func execute():
	fn.call()
