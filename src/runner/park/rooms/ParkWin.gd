@tool
# ParkWin
extends RunnerRoom


func _ready():
	U._connect(player_entered, _on_player_entered)


func _on_player_entered(p):
	p.stop_running()
