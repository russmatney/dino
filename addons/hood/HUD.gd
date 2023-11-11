extends CanvasLayer
class_name HUD


func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))

func _on_entry_updated(entry):
	if entry == null:
		return
	if "player" in entry.get("groups", []):
		_on_player_update(entry)
	if "enemies" in entry.get("groups", []):
		_on_enemy_update(entry)

func _on_player_update(player):
	Log.warn("player update not impled")

func _on_enemy_update(enemy):
	Log.warn("enemy update not impled")
