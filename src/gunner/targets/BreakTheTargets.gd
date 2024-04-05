extends Quest
class_name QuestBreakTheTargets

## ready ##########################################################

func _init():
	label = "Break The Targets"
	xs_group = "targets"
	x_update_signal = func(t): return t.destroyed
	is_remaining = func(t): return not t.is_dead

func on_quest_update(opts):
	var remaining = opts.get("remaining")
	var destroyed = total - remaining

	if destroyed > 0:
		Debug.notif({
			icon_texture="target",
			text="Target Destroyed (%d/%d)" % [destroyed, total],
			id="quest-btt",
			})
