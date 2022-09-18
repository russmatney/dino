extends PopupPanel

# TODO configure main menu scene in a Navi editor tool
func _on_ReturnToMain_pressed():
	# TODO should probably be Navi.go_to_main_menu()
	Navi.nav_to("res://src/menus/MainMenu.tscn")
	Navi.hide_win_menu()
