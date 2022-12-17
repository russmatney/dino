extends PopupPanel

func _on_ReturnToMain_pressed():
	Navi.nav_to_main_menu()
	Navi.hide_win_menu()
