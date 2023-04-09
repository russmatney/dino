extends CanvasLayer


func _ready():
	Debug.pr("ready")
	var _x = Hood.found_player.connect(setup_player)
	Hood.find_player.call_deferred()


###################################################################
# player setup

var player

func setup_player(p):
	player = p
	player.step.connect(update_steps)
	player.speed_increased.connect(update_speed)
	player.food_picked_up.connect(update_food_score)
	player.inc_combo_juice.connect(update_combo_juice)
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
