extends NaviPauseMenu

func _ready():
	print("tower pause menu")


func _on_Restart_pressed():
	hide()
	Tower.restart_game()
