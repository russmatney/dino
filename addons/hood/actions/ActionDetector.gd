@tool
class_name ActionDetector
extends Area2D

####################################################################
# ready

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

var actor:
	set(a):
		actor = a
		# detectable by ActionAreas
		actor.add_to_group("actors", true)
		Hood.prn("actor configured: ", a)

####################################################################
# process

func _process(_delta):
	if not Engine.is_editor_hint():
		Hood.debug_label("immediate_actions: ", immediate_actions())
		Hood.debug_label("potential_actions: ", potential_actions())


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
	Hood.debug_label("action areas: ", action_areas)

	update_actions()

####################################################################
# actions

var actions = []

func update_actions():
	actions = []
	for area in action_areas:
		actions.append_array(area.actions)

	Hood.debug_label("actions: ", actions)

	update_hint()

	# maybe reset here
	# selected_ax_idx = 0


## Returns actions that can be immediately executed
func immediate_actions():
	if actor:
		return actions.filter(func(ax): return ax.can_execute_now(actor))

## Returns actions that could be performed if we were close enough to the source.
## The actor has no other hang ups (missing dependent items/whatever).
func potential_actions():
	if actor:
		return actions.filter(func(ax): return ax.could_execute(actor))

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
	update_hint()

func dec_selected_ax_idx():
	var im_axs = immediate_actions()
	if im_axs != null and len(im_axs) > 0:
		selected_ax_idx -= 1 % len(im_axs)
	update_hint()

func execute_current_action():
	var c_ax = current_action()
	if c_ax:
		c_ax.execute()
	update_hint()

func update_hint():
	if actor:
		actor.update_action_hint(current_action())
