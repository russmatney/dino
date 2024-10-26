extends CanvasLayer

func _ready():
	Debug.debug_toggled.connect(_on_debug_toggled)
	_on_debug_toggled(Debug.debugging)

func _on_debug_toggled(debugging):
	set_visible(debugging)
