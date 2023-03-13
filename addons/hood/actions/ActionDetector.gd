@tool
class_name ActionDetector
extends Area2D

####################################################################
# ready

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

var actor
var action_hint

var can_execute_any_actions = func(): return true

func setup(a, can_execute_any=null, ac_hint=null):
	actor = a
	# required to be added to ActionAreas
	actor.add_to_group("actors", true)
	Debug.prn("actor configured: ", a)

	if can_execute_any:
		can_execute_any_actions = can_execute_any

	if ac_hint:
		action_hint = ac_hint

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
	# Debug.debug_label("action areas: ", action_areas)

	update_actions()

####################################################################
# actions

var actions = []

func update_actions():
	actions = []
	for area in action_areas:
		actions.append_array(area.actions)

	# Debug.debug_label("actions: ", actions)

	update_displayed_action()

	# maybe reset here
	# selected_ax_idx = 0


## Returns actions that can be immediately executed
func immediate_actions():
	if actor and can_execute_any_actions.call():
		return actions.filter(func(ax): return ax.can_execute_now(actor))

## Returns actions that could be performed if we were close enough to the source.
## The actor has no other hang ups (missing dependent items/whatever).
func potential_actions():
	if actor and can_execute_any_actions.call():
		return actions.filter(func(ax): return ax.can_execute(actor))

####################################################################
# current, selecting an action

var selected_ax_idx = 0

func current_action():
	var im_axs = immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		if selected_ax_idx != null and selected_ax_idx < len(im_axs):
			return im_axs[selected_ax_idx]

func inc_selected_ax_idx():
	var im_axs = immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		selected_ax_idx += 1 % len(im_axs)
	update_displayed_action()

func dec_selected_ax_idx():
	var im_axs = immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		selected_ax_idx -= 1 % len(im_axs)
	update_displayed_action()

func execute_current_action():
	var c_ax = current_action()
	if c_ax:
		c_ax.execute()
	update_displayed_action()

func update_displayed_action():
	if actor and actor.has_method("update_displayed_action"):
		actor.update_displayed_action(current_action())
	elif action_hint:
		var c_ax = current_action()
		if c_ax:
			action_hint.display(c_ax.input_action, c_ax.get_label())
		else:
			action_hint.hide()
