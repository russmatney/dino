extends Control

func _on_Button_pressed():
	# TODO provide this in Navi without spreading the path around
	# via a configurable 'main menu' scene
	Navi.nav_to("res://src/menus/DinoMenu.tscn")
