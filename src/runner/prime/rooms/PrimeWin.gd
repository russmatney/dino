@tool
extends RunnerRoom


func _ready():
	Util._connect(player_entered, _on_player_entered)


func _on_player_entered(p):
	p.won = true

	p.stop_running()
