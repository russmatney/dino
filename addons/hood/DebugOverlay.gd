extends CanvasLayer

func _ready():
	Debug.debug_toggle.connect(_on_debug_toggle)

func _on_debug_toggle(debugging):
	set_visible(debugging)
