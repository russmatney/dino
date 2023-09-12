extends CanvasLayer

func _ready():
	Debug.pr("DotHop hud ready")
	Hotel.entry_updated.connect(_on_entry_updated)

func _on_entry_updated(entry):
	Debug.pr("entry updated", entry)
