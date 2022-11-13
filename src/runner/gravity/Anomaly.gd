extends RunnerRoom

var max_runs = 3
var runs = 0

func _ready():
	Util.ensure_connection(self, "player_entered", self, "_on_player_entered")

func _on_player_entered(player):
	runs = runs + 1

func is_finished():
	print(self, "is funished? runs: ", runs)

	return runs >= max_runs
