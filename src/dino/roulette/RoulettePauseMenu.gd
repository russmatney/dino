extends CanvasLayer

@onready var regen_menu = $%BrickRegenMenu

func _ready():
	Debug.pr("pause menu ready")
	refresh()

	visibility_changed.connect(func(): if visible: refresh())


func refresh():
	regen_menu.setup()
