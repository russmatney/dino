extends PopupPanel

# TODO tests for this scene

### ready ##################################################################


func _ready():
	# TODO validate connections
	pass


### handlers ##################################################################


func _on_ReturnToMain_pressed():
	# TODO is there some way to auto-assert if this is missing?
	# could give a helper func here if we had some main-menu-opt-in ui
	# feels like we need a configuration UI...
	# TODO nav_to should automatically resume
	Navi.nav_to("res://src/menus/MainMenu.tscn")
	Navi.resume()


func _on_Resume_pressed():
	hide()
	# NOTE resume also `hides` the popup, if it's known
	# but it's good practice to include the `hide()` here
	# in case some consumer has opt-ed out
	Navi.resume()
