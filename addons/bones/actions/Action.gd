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
var source_can_execute: Callable = func() -> bool: return true
var actor_can_execute: Callable = func(_a: Node) -> bool: return true
var area: ActionArea
var requires_proximity: bool = true
var maximum_distance: float
var requires_line_of_sight: bool = true
var show_on_source: bool = true
var show_on_actor: bool = true

#################################################################
# get_label

func get_label() -> String:
	if label_fn:
		var lbl: String = label_fn.call()
		if lbl:
			return lbl
	if label:
		return label
	Log.warn("No label specified for action", self)
	return "action"

#################################################################
# to string

func to_pretty() -> Variant:
	return {label=get_label()}

func _to_string() -> String:
	if source:
		return "Action: %s on source: %s" % [get_label(), source]
	else:
		return "Action: %s" % get_label()

#################################################################
# constructor

static func mk(opts: Dictionary) -> Action:
	var ax := Action.new()
	ax.fn = opts.get("fn", func() -> void: Log.info("No-op action"))

	ax.label = opts.get("label", "Action")
	var lbl_f: Variant = opts.get("label_fn")
	if lbl_f != null:
		ax.label_fn = lbl_f

	var src: Variant = opts.get("source")
	if src != null:
		ax.source = src

	var _input_action: Variant = opts.get("input_action")
	if _input_action != null:
		ax.input_action = _input_action

	var _source_can_execute: Variant = opts.get("source_can_execute")
	if _source_can_execute != null:
		ax.source_can_execute = _source_can_execute

	var _actor_can_execute: Variant = opts.get("actor_can_execute")
	if _actor_can_execute != null:
		ax.actor_can_execute = _actor_can_execute

	var _requires_proximity: Variant = opts.get("requires_proximity")
	if _requires_proximity != null:
		ax.requires_proximity = _requires_proximity

	var _maximum_distance: Variant = opts.get("maximum_distance")
	if _maximum_distance != null:
		ax.maximum_distance = _maximum_distance
		ax.requires_proximity = true

	var _requires_line_of_sight: Variant = opts.get("requires_line_of_sight")
	if _requires_line_of_sight != null:
		ax.requires_line_of_sight = _requires_line_of_sight

	var _show_on_source: Variant = opts.get("show_on_source")
	if _show_on_source != null:
		ax.show_on_source = _show_on_source

	var _show_on_actor: Variant = opts.get("show_on_actor")
	if _show_on_actor != null:
		ax.show_on_actor = _show_on_actor

	return ax

#################################################################
# conditionals

func can_execute_now(actor: Node2D) -> bool:
	return can_execute(actor) and close_enough_to_execute(actor) and has_line_of_sight(actor)

func can_execute(actor: Node) -> bool:
	return source_can_execute.call() and actor_can_execute.call(actor)

# Note this returns true if there is no assigned source.
func close_enough_to_execute(actor: Node2D) -> bool:
	if source != null and requires_proximity:
		if maximum_distance != 0.0:
			if area.source == null:
				Log.err("Cannot support `maximum_distance` without `area.source`")
			else:
				var src: Node2D = area.source
				var dist := actor.global_position.distance_to(src.global_position)
				return dist <= maximum_distance
		return actor in area.actors
	return true

func has_line_of_sight(_actor: Node) -> bool:
	if source == null:
		# no source? don't care, action can fire
		return true

	if requires_line_of_sight:
		# impl LOS between actor and action_source
		return true
	else:
		return true

#################################################################
# execute

func execute(actor: Node = null) -> void:
	fn.call(actor)
