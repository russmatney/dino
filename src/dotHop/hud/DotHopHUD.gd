extends HUD


func _ready():
	Debug.pr("DotHop hud ready")

func _on_entry_updated(entry):
	Debug.pr("entry updated", entry)
