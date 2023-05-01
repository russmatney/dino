@tool
class_name ActionArea
extends Area2D

signal action_display_updated()

####################################################################
# ready

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

####################################################################
# actions registry

var actions: Array = []

## register actions to be detected from this area
func register_actions(axs, source=null):
	for ax in axs:
		if source and not ax.source:
			ax.source = source
		ax.area = self
	actions = axs

####################################################################
# bodies

var actors = []

func _on_body_entered(body):
	if body.is_in_group("actors"):
		actors.append(body)
		update_actor_actions(body)

func _on_body_exited(body):
	if body.is_in_group("actors"):
		actors.erase(body)
		update_actor_actions(body)

func update_actor_actions(actor):
	if actor.action_detector:
		actor.action_detector.update_displayed_action()

	action_display_updated.emit()

####################################################################
# ask if an action can be performed

func is_current_for_any_actor(action):
	for actor in actors:
		if actor.action_detector:
			if action == actor.action_detector.current_action():
				return true
	return false

## Returns any actions in this area's actions list that an actor
## has as a 'current' (immediate and nearest) action.
func current_actions():
	var current_axs = {}
	for actor in actors:
		if actor.action_detector:
			var c_ax = actor.action_detector.current_action()
			if c_ax in actions:
				current_axs[c_ax.label] = c_ax
	return current_axs.values()
