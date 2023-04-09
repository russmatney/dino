@tool
class_name Action
extends Object

#################################################################
# fields

var fn: Callable
var label: String = "Action"
var label_fn: Callable
var input_action: String = "action"
var source: Node
var source_can_execute: Callable = func(): return true
var actor_can_execute: Callable = func(_a): return true
var area
var requires_proximity: bool = true
var requires_line_of_sight: bool = true

#################################################################
# get_label

func get_label():
	if label_fn:
		return label_fn.call()
	return label

#################################################################
# to string

func _to_string():
	if source:
		return "Action: %s on source: %s" % [get_label(), source]
	else:
		return "Action: %s" % get_label()

#################################################################
# constructor

static func mk(opts) -> Action:
	var ax = Action.new()
	ax.fn = opts.get("fn", func(): Debug.pr("No-op action"))

	ax.label = opts.get("label", "Action")
	var label_fn = opts.get("label_fn")
	if label_fn != null:
		ax.label_fn = label_fn

	var input_action = opts.get("input_action")
	if input_action != null:
		ax.input_action = input_action

	var source_can_execute = opts.get("source_can_execute")
	if source_can_execute != null:
		ax.source_can_execute = source_can_execute

	var actor_can_execute = opts.get("actor_can_execute")
	if actor_can_execute != null:
		ax.actor_can_execute = actor_can_execute

	var requires_proximity = opts.get("requires_proximity")
	if requires_proximity != null:
		ax.requires_proximity = requires_proximity

	var requires_line_of_sight = opts.get("requires_line_of_sight")
	if requires_line_of_sight != null:
		ax.requires_line_of_sight = requires_line_of_sight

	return ax

#################################################################
# conditionals

func can_execute_now(actor) -> bool:
	return can_execute(actor) and close_enough_to_execute(actor) and has_line_of_sight(actor)

func can_execute(actor) -> bool:
	return source_can_execute.call() and actor_can_execute.call(actor)

func close_enough_to_execute(actor) -> bool:
	if requires_proximity:
		return actor in area.actors
	return true

func has_line_of_sight(actor) -> bool:
	if requires_line_of_sight:
		# TODO impl LOS between actor and action_source
		return true
	else:
		return true

#################################################################
# execute

# TODO args?
func execute(actor=null):
	fn.call(actor)
