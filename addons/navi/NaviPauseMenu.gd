class_name NaviPauseMenu
extends PopupPanel

# TODO tests for this scene

### ready ##################################################################


func _ready():
	# TODO validate connections
	pass


### handlers ##################################################################


func _on_ReturnToMain_pressed():
	Navi.nav_to_main_menu()
	Navi.resume()


func _on_Resume_pressed():
	hide()
	# NOTE resume also `hides` the popup, if it's known
	# but it's good practice to include the `hide()` here
	# in case some consumer has opt-ed out
	Navi.resume()
