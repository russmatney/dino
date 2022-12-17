extends PopupPanel

func _on_ReturnToMain_pressed():
	Navi.hide_death_menu()
	Navi.nav_to_main_menu()
