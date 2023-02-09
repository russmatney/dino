@tool
extends RunnerRoom


func _ready():
	Util.ensure_connection(self, "player_entered", self, "_on_player_entered")


func _on_player_entered(player):
	player.stop_running()
