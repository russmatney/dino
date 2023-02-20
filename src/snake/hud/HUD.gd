extends CanvasLayer


func _ready():
	Hood.prn("ready")
	var _x = Hood.connect("found_player",Callable(self,"setup_player"))
	Hood.call_deferred("find_player")


###################################################################
# player setup

var player

func setup_player(p):
	player = p
	player.connect("step",Callable(self,"update_steps"))
	player.connect("speed_increased",Callable(self,"update_speed"))
	player.connect("food_picked_up",Callable(self,"update_food_score"))
	player.connect("inc_combo_juice",Callable(self,"update_combo_juice"))
	update_speed()
	update_steps()
	update_food_score()
	update_combo_juice()


func update_speed():
	get_node("%Speed").text = str("Speed: ", player.speed_level)

func update_steps():
	get_node("%StepCount").text = str("Steps: ", player.step_count)

func update_food_score(_food=null):
	get_node("%FoodCount").text = str("Food: ", player.food_count)

func update_combo_juice(juice=null):
	get_node("%ComboJuice").text = str("Combo: ", juice)
