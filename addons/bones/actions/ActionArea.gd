@tool
class_name ActionArea
extends Area2D

signal action_display_updated()

####################################################################
# ready

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if not source:
		var p := get_parent()
		p.ready.connect(func() -> void:
			var axs := []
			if p.get("actions"): # maybe better to call a method
				@warning_ignore("unsafe_property_access")
				axs = p.actions
			if not axs.is_empty():
				register_actions(axs, {source=p}))

####################################################################
# actions registry

var actions: Array = []
var action_hint: ActionHint
var source: Node

## register actions to be detected from this area
func register_actions(axs: Array, opts := {}) -> void:
	source = opts.get("source")

	if not action_hint:
		for ch in source.get_children():
			if ch is ActionHint:
				action_hint = ch
				break
	if action_hint:
		action_hint.hide()

	actions = axs
	for ax: Action in actions:
		if source and not ax.source:
			ax.source = source
		ax.area = self

####################################################################
# bodies

var actors := []

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("actors"):
		@warning_ignore("unsafe_property_access")
		var action_detector: ActionDetector = body.action_detector
		actors.append(body)
		U._connect(action_detector.current_action_changed, update_displayed_action)
		action_detector.current_action()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("actors"):
		@warning_ignore("unsafe_property_access")
		var action_detector: ActionDetector = body.action_detector
		actors.erase(body)
		action_detector.current_action()

func update_displayed_action(action: Action = null) -> void:
	if action_hint:
		if action and source and action.source == source and action.show_on_source:
			action_hint.display(action.input_action, action.get_label())
		else:
			action_hint.hide()

	action_display_updated.emit()


####################################################################
# ask if an action can be performed

func is_current_for_any_actor(action: Action) -> bool:
	for actor: Node in actors:
		if actor.get("action_detector"):
			@warning_ignore("unsafe_property_access")
			var action_detector: ActionDetector = actor.action_detector
			if action == action_detector.current_action():
				return true
	return false

## Returns any actions in this area's actions list that an actor
## has as a 'current' (immediate and nearest) action.
func current_actions() -> Array:
	var current_axs := {}
	for actor: Node in actors:
		if actor.get("action_detector"):
			@warning_ignore("unsafe_property_access")
			var action_detector: ActionDetector = actor.action_detector
			var c_ax := action_detector.current_action()
			if c_ax in actions:
				current_axs[c_ax.label] = c_ax
	return current_axs.values()
