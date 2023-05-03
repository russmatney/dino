extends CanvasLayer


func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)

func _on_entry_updated(entry):
	if "player" in entry.get("groups", []):
		set_health(entry.get("health"))

func set_health(health):
	if health == null:
		return
	$%HeartsContainer.h = health
