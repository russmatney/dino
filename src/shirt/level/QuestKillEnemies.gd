extends Quest
class_name QuestKillAllEnemies

## ready ##########################################################

func _init():
	label = "Kill All Enemies"
	xs_group = "enemies"
	x_update_signal = func(x): return x.died
	is_remaining = func(x): return not x.is_dead

func update_quest(_x=null):
	Log.pr("kill all enemies update!", _x)
	super.update_quest(_x)
