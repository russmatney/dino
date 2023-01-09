extends NaviPauseMenu

func _ready():
	print("harvey pause menu")


func _on_Restart_pressed():
	hide()
	Harvey.restart_game()
