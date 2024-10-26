class_name ActionDetector
extends Area2D

## vars ###################################################################

var actor
var action_hint
var actor_actions

# used to prevent player actions, e.g. while sitting
var can_execute_any_actions = func(): return true

## ready ###################################################################

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	current_action_changed.connect(update_displayed_action)

	if not actor:
		var p = get_parent()
		p.ready.connect(func(): setup(p))

## setup ###################################################################

func setup(a, opts={}):
	actor = a
	# required to be added to ActionAreas
	actor.add_to_group("actors", true)

	var ac_hint = opts.get("action_hint")
	if not ac_hint:
		for ch in actor.get_children():
			if ch is ActionHint:
				ac_hint = ch
				break
	action_hint = ac_hint

	var acts = opts.get("actions", [])
	if actor.get("actions"): # maybe better to call a method
		acts = actor.actions
	actor_actions = acts

	var can_exec = opts.get("can_execute_any")
	if not can_exec and actor.has_method("can_execute_any"):
		can_exec = actor.can_execute_any
	if not can_exec:
		can_exec = func(): return true
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

var action_areas = []
var action_areas_group = "action_areas"

func _on_area_entered(area):
	if area.is_in_group(action_areas_group):
		action_areas.append(area)
		update_action_areas()

func _on_area_exited(area):
	if area.is_in_group(action_areas_group):
		action_areas.erase(area)
		update_action_areas()

func update_action_areas():
	update_actions()

####################################################################
# actions

var actions = []

func update_actions():
	actions = []
	actions.append_array(actor_actions)
	for area in action_areas:
		actions.append_array(area.actions)

	current_action()

	# maybe reset selection here? probably should maintain the current if it still exists
	# selected_ax_idx = null


## Returns actions that can be immediately executed
func immediate_actions():
	if actor and can_execute_any_actions.call():
		return actions.filter(func(ax): return ax.can_execute_now(actor))

## Returns actions that could be performed if we were close enough to the source.
## The actor has no other hang ups (missing dependent items/whatever).
func potential_actions():
	if actor and can_execute_any_actions.call():
		return actions.filter(func(ax): return ax.can_execute(actor))

## Returns the nearest of all the actions, regardless of executability.
func find_nearest(axs=actions):
	# should filter/sort by line-of-sight
	var srcs = axs.filter(func(ax): return ax.source).map(func(ax): return ax.source)
	var nearest_src = U.nearest_node(self, srcs)
	if not nearest_src:
		return
	# sources with multiple actions - which action to return?
	var nearest = axs.filter(func(ax): return ax.source == nearest_src)
	# this just returns a matching action for the nearest source
	if nearest.size() > 0:
		return nearest[0]

func sort_nearest(axs=actions):
	# should implement, and don't filter out sourceless axs
	return axs

## Return the nearest immediate action. If none, return the nearest potential action.
## Proximity is calced using the actor and the action's source node.
## Line Of Sight is opt-in per action, and should be sorted last. (should be, pending implementation).
func nearest_action():
	var im_axs = immediate_actions()
	if im_axs.size() > 0:
		var nearest_ax = find_nearest(im_axs)
		if nearest_ax:
			return nearest_ax

	var pot_axs = potential_actions()
	if pot_axs.size() > 0:
		var nearest_ax = find_nearest(pot_axs)
		if nearest_ax:
			return nearest_ax

	return find_nearest()

####################################################################
# current, selecting an action

var selected_ax_idx

signal current_action_changed(action)
var cached_current_action

## Returns the current action. Defaults to the nearest 'immediate' action,
## but if selected_ax_idx is set, it will return the 'immediate' action at that index.
##
## NOTE side-effects! this function emits `current_action_changed`
## when the value changes, causing ui (action_hint) updates
func current_action():
	var im_axs = immediate_actions()
	var new_current_action
	if im_axs != null and len(im_axs) > 0:
		var sorted = sort_nearest(im_axs)
		var idx = 0
		if selected_ax_idx != null and selected_ax_idx < len(im_axs):
			idx = selected_ax_idx
		new_current_action = sorted[idx]
	else:
		# clear when there are no actions
		selected_ax_idx = null
	if new_current_action != cached_current_action:
		cached_current_action = new_current_action
		current_action_changed.emit(new_current_action)
	return new_current_action

## Supports cycling forward through available actions.
func cycle_next_action():
	var im_axs = immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		if selected_ax_idx == null:
			selected_ax_idx = 0
		selected_ax_idx += 1
		selected_ax_idx %= len(im_axs)
	current_action()

## Supports cycling backwards through available actions.
func cycle_prev_action():
	var im_axs = immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		if selected_ax_idx == null:
			selected_ax_idx = 0
		selected_ax_idx -= 1
		if selected_ax_idx == -1:
			selected_ax_idx = len(im_axs) - 1
	current_action()

## Executes the result of `current_action()`.
## Does nothing if there is no 'immediate' action available.
func execute_current_action():
	var c_ax = current_action()
	if c_ax:
		c_ax.execute(actor)
		current_action()
		selected_ax_idx = null
		return true
	return false

####################################################################
# action display

var warned_no_action_hint
func update_displayed_action(action=null):
	if action_hint:
		var c_ax
		if action == null:
			c_ax = current_action()
		else:
			c_ax = action

		if c_ax and c_ax.show_on_actor:
			action_hint.display(c_ax.input_action, c_ax.get_label())
		else:
			action_hint.hide()
	else:
		if not warned_no_action_hint:
			Log.warn("Cannot display available action, no action_hint")
			warned_no_action_hint = true
