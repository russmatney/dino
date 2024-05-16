extends CanvasLayer

@onready var return_button = $%ReturnToMain

func _ready():
	Log.pr("options panel")

	return_button.pressed.connect(Navi.nav_to_main_menu)
