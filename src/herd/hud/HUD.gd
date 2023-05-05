extends CanvasLayer


func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))

func _on_entry_updated(entry):
	if "player" in entry.get("groups", []):
		set_health(entry.get("health"))

func set_health(health):
	if health == null:
		return
	$%HeartsContainer.h = health
