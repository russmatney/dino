extends RunnerRoom

var max_runs = 3
var runs = 0


onready var block = $Block
var block_pos
onready var block_two = $Block2
var block_two_pos


func _ready():
	Util.ensure_connection(self, "player_entered", self, "_on_player_entered")

	block_pos = block.global_position
	block_two_pos = block_two.global_position

func reset():
	block.position = block_pos
	block_two.position = block_two_pos


func _on_player_entered(player):
	print("player entered")

	reset()

	runs = runs + 1




func is_finished():
	print(self, "is funished? runs: ", runs)

	return runs >= max_runs
