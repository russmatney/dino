extends CanvasLayer


func _ready():
	print("[snake] HUD ready")
	var _x = Hood.connect("found_player", self, "setup_player")
	Hood.call_deferred("find_player")


###################################################################
# player setup

var player

func setup_player(p):
	player = p

	player.connect("food_picked_up", self, "update_food_score")
	update_food_score()


func update_food_score():
	get_node("%FoodCount").text = str("Food: ", player.food_count)
