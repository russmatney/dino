extends Quest
class_name QuestKillAllEnemies

## ready ##########################################################

func _init():
	label = "Kill All Enemies"
	xs_group = "enemies"
	x_update_signal = func(x): return x.died
	is_remaining = func(x): return not x.is_dead

func update_quest(_x=null):
	if _x:
		Log.pr("kill all enemies update!", _x)
	else:
		Log.pr("kill all enemies update!")
	super.update_quest(_x)
