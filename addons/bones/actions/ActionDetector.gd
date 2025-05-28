class_name ActionDetector
extends Area2D

## vars ###################################################################

var actor: Node
var action_hint: ActionHint
var actor_actions: Array

# used to prevent player actions, e.g. while sitting
var can_execute_any_actions := func() -> bool: return true

## ready ###################################################################

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	current_action_changed.connect(update_displayed_action)

	if not actor:
		var p := get_parent()
		p.ready.connect(func() -> void: setup(p))

## setup ###################################################################

func setup(a: Node, opts := {}) -> void:
	actor = a
	# required to be added to ActionAreas
	actor.add_to_group("actors", true)

	var ac_hint: ActionHint = opts.get("action_hint")
	if not ac_hint:
		for ch in actor.get_children():
			if ch is ActionHint:
				ac_hint = ch
				break
	action_hint = ac_hint

	var acts: Array = opts.get("actions", [])
	if actor.get("actions"): # maybe better to call a method
		@warning_ignore("unsafe_property_access")
		acts = actor.actions
	actor_actions = acts

	var can_exec: Variant = opts.get("can_execute_any")
	if not can_exec and actor.has_method("can_execute_any"):
		@warning_ignore("unsafe_property_access")
		can_exec = actor.can_execute_any
	if not can_exec:
		can_exec = func() -> bool: return true
	can_execute_any_actions = can_exec

	update_actions()

####################################################################
# process

# func _process(_delta):
# 	if not Engine.is_editor_hint():
# 		Debug.debug_label("immediate_actions: ", immediate_actions())
# 		Debug.debug_label("potential_actions: ", potential_actions())


####################################################################
# action area add/remove

var action_areas := []
var action_areas_group := "action_areas"

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group(action_areas_group):
		action_areas.append(area)
		update_action_areas()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group(action_areas_group):
		action_areas.erase(area)
		update_action_areas()

func update_action_areas() -> void:
	update_actions()

####################################################################
# actions

var actions := []

func update_actions() -> void:
	actions = []
	actions.append_array(actor_actions)
	for area: ActionArea in action_areas:
		actions.append_array(area.actions)

	current_action()

	# maybe reset selection here? probably should maintain the current if it still exists
	# selected_ax_idx = null


## Returns actions that can be immediately executed
func immediate_actions() -> Array:
	if actor and can_execute_any_actions.call():
		return actions.filter(func(ax: Action) -> bool: return ax.can_execute_now(actor))
	return []

## Returns actions that could be performed if we were close enough to the source.
## The actor has no other hang ups (missing dependent items/whatever).
func potential_actions() -> Array:
	if actor and can_execute_any_actions.call():
		return actions.filter(func(ax: Action) -> bool: return ax.can_execute(actor))
	return []

## Returns the nearest of all the actions, regardless of executability.
func find_nearest(axs: Array = actions) -> Action:
	# should filter/sort by line-of-sight
	var srcs := axs.filter(func(ax: Action) -> bool: return ax.source != null).map(func(ax: Action) -> Node: return ax.source)
	var nearest_src := U.nearest_node(self, srcs)
	if not nearest_src:
		return
	# sources with multiple actions - which action to return?
	var nearest := axs.filter(func(ax: Action) -> bool: return ax.source == nearest_src)
	# this just returns a matching action for the nearest source
	if nearest.size() > 0:
		return nearest[0]
	return

func sort_nearest(axs: Array = actions) -> Array:
	# should implement, and don't filter out sourceless axs
	return axs

## Return the nearest immediate action. If none, return the nearest potential action.
## Proximity is calced using the actor and the action's source node.
## Line Of Sight is opt-in per action, and should be sorted last. (should be, pending implementation).
func nearest_action() -> Action:
	var im_axs := immediate_actions()
	if im_axs.size() > 0:
		var nearest_ax := find_nearest(im_axs)
		if nearest_ax:
			return nearest_ax

	var pot_axs := potential_actions()
	if pot_axs.size() > 0:
		var nearest_ax := find_nearest(pot_axs)
		if nearest_ax:
			return nearest_ax

	return find_nearest()

####################################################################
# current, selecting an action

var selected_ax_idx: int = -1

signal current_action_changed(action: Action)
var cached_current_action: Action

## Returns the current action. Defaults to the nearest 'immediate' action,
## but if selected_ax_idx is set, it will return the 'immediate' action at that index.
##
## NOTE side-effects! this function emits `current_action_changed`
## when the value changes, causing ui (action_hint) updates
func current_action() -> Action:
	var im_axs := immediate_actions()
	var new_current_action: Action
	if im_axs != null and len(im_axs) > 0:
		var sorted := sort_nearest(im_axs)
		var idx := 0
		if selected_ax_idx > -1 and selected_ax_idx < len(im_axs):
			idx = selected_ax_idx
		new_current_action = sorted[idx]
	else:
		# clear when there are no actions
		selected_ax_idx = -1
	if new_current_action != cached_current_action:
		cached_current_action = new_current_action
		current_action_changed.emit(new_current_action)
	return new_current_action

## Supports cycling forward through available actions.
func cycle_next_action() -> void:
	var im_axs := immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		if selected_ax_idx > -1:
			selected_ax_idx = 0
		selected_ax_idx += 1
		selected_ax_idx %= len(im_axs)
	current_action()

## Supports cycling backwards through available actions.
func cycle_prev_action() -> void:
	var im_axs := immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		if selected_ax_idx > -1:
			selected_ax_idx = 0
		selected_ax_idx -= 1
		if selected_ax_idx == -1:
			selected_ax_idx = len(im_axs) - 1
	current_action()

## Executes the result of `current_action()`.
## Does nothing if there is no 'immediate' action available.
func execute_current_action() -> bool:
	var c_ax := current_action()
	if c_ax:
		c_ax.execute(actor)
		current_action()
		selected_ax_idx = -1
		return true
	return false

####################################################################
# action display

var warned_no_action_hint: bool
func update_displayed_action(action: Action = null) -> void:
	if action_hint:
		var c_ax: Action
		if action == null:
			c_ax = current_action()
		else:
			c_ax = action

		if c_ax and c_ax.show_on_actor:
			action_hint.display(c_ax.input_action, c_ax.get_label())
		else:
			action_hint.hide_action_hint()
	else:
		if not warned_no_action_hint:
			Log.warn("Cannot display available action, no action_hint")
			warned_no_action_hint = true
